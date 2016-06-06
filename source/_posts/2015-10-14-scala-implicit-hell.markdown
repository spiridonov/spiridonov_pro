---
layout: post
title: Make them suffer / Scala implicit hell
date: 2015-10-14
comments: true
language: en
description: Scala implicit hell. Implicit parameters, implicit conversions. Handling dependencies. Make them suffer is a series of posts about Scala and Akka.
---

{% img center /images/make-them-suffer/title-2.jpg %}

_Make them suffer_ is a series of posts about Scala and Akka. [Previously](/2015/10/08/akka-internal-state) we discussed how to avoid concurrency problems and keeping internal actors state isolated in Akka. In this episode I want to show you why Scala code looks so magical and hard to undersrand. But I'm gonna start with a long introduction.

## Dependencies everywhere

Dealing with dependencies has been always painful. It doesn't really depend on a size of a project. You start feeling this pain after some period of time, when you add new features into existing project or do refactorings. They also make harder to test your code.

Depending on a programming language there are different kinds of dependencies. Global variable is the simpliest one (in C, Delphi, etc). Or it could be any kind of global state: singletons, static fields, global configs, thread locals, etc (basically any language ever). Or service A needs service B to do its duties. Even when you refer to class X (to create an instance of it) from the inside of class Y, it is also a dependency. 

As time goes people collect useful experience and extract smart ideas into form of books (GoF is a must read book). Some things are considered as anti-patterns now (such as singletons, global variables, etc). Other things have been born to organize this mess (policy pattern, etc). The main recommendation how to deal with dependencies is: __do not refer to anything from the inside, instead pass dependencies explicitly from the outside__. This is called [inversion of control](https://en.wikipedia.org/wiki/Inversion_of_control).

It works, yes. Your code is less coupled now and easier to refactor and test. But in a big project code gets bloated with zillions of arguments passed all around, long function calls and boilerplate code. Different techniques exist to solve this problem. [Dependency injection](https://en.wikipedia.org/wiki/Dependency_injection) is one of them. Popular DI frameworks (Spring, Guice, etc) do some magic and bind dependencies at run-time, so you don't need to create objects and pass dependencies to it manually. Usually they use bytecode manipulations or reflection (annotations) to construct objects and inject dependencies.

Unfortunately some languages do not support any runtime magic or bytecode manipulations, so automatic injections are not possible. [Service locator](https://en.wikipedia.org/wiki/Service_locator_pattern) pattern helps in this case. A class could ask service locator to give any service it needs (usually by name or interface) at run-time.

## Scala's implicits

Scala creators knew about this problem and suggested thier solution to it. Dependencies should be solved at compile-time yet boilerplate code should be reduced as much as possible. Syntatically! So, yeah... Meet __implicit parameters__. They are passed to functions implicitly, hence the name. Implicit parameters has no runtime performance cost at all. This resolving is done completely at compile-time. Yes, Scala compiler is slow. It does many many things and resolving implicit parameters is one of them. When compiler meets a function with an implicit parameter it looks up a variable of particular type in a current scope. If it finds nothing – it explodes. If it finds more than one variable of this type – it explodes as well.

The next simple example shows the main advantage of implicit parameters:

{% codeblock lang:scala %}
import scala.concurrent._
import scala.concurrent.ExecutionContext.Implicits.global

val beast = hell.createBeastFor(credentials)
val f: Future[Option[Blood]] = Future {
  beast.rape(user)
}
{% endcodeblock %}

To execute a future an execution context is needed. In poorly designed systems it probably would be like that: there would be just one global thread pool directly used from the inside of futures implementation, a pool would be configured from a global config file (or whatever), there would be no way to use two different pools for different purposes, and so forth.

The implementation of `Future` in Scala is not coupled to any execution context. At the same time the code for creating a future looks sexy. How? Lets take a look at `scala.concurrent.Future` companion object's [documentation](http://www.scala-lang.org/api/2.11.7/index.html#scala.concurrent.Future$):

{% codeblock lang:scala %}
def apply[T](body: => T)(implicit execctx: ExecutionContext): Future[T]
{% endcodeblock %}

There are two arguments: `body` and `execctx`. The latter is implicit and there is no need to pass it every single time you create a future. If you are ok with default execution context you can just `import scala.concurrent.ExecutionContext.Implicits.global` and that's it! If you really need a spicific execution context you can set an implicit `val` with this context near correspondent future creation, or you can even pass this argument explicitly.

A rule of thumb is not to use general types for implicit parameters. It easily could happen that several implicit `String` variables are presented in a scope for different purposes. With concrete services like `ExecutionContext` it works ok.

Then Scala creators went even crazier and introduced implicit conversions. This is a typesafe way to extend existing classes. Monkeypatching in Ruby serves the similar purpose, but always in a horrible and dangerous way. Lets take a look at classic example:

{% codeblock lang:scala %}
(1 to 5).foreach(println)
{% endcodeblock %}

Expression `1 to 5` creates a `Range`. The thing is that there is no method `to` in the `Int` class (`1` is `Int` obviously). This method [exists](http://www.scala-lang.org/api/rc/index.html#scala.runtime.RichInt) in `RichInt` class. But how does the compiler deside to use `RichInt` class here instead of `Int`? Thanks to [this implicit conversion](https://github.com/scala/scala/blob/27da46343cd545534819300235bc64ab74958c92/src/library/scala/Predef.scala#L477). It's a double win, they said: `Int` class is still clear from methods not related directly to integers, and a code for creating ranges looks sexy.

## Infinite misery

Scala programming goes together with pain. Implicits make Scala code look sexy yet impossible to understand. Sad but true, it is easy to write, but not to understand. A huge part of Scala's magic is done by implicits. Dependencies are resolved at compile-time, you write less code, there is no boilerplate, classes are loosely coupled, everything is extendable yet still typesafe. But reading a code in a book, article or existing project requires two times more mental power to follow a path. It is common to use package objects with implicits, so there is no way to eyeball that this small import on top of a file feeds several function calls with implicit variables. Even worse, it is impossible to understand from a code that this particular function call needs implicits.

IDE doesn't really help. My IDEA doesn't warn me when I lack of necessary implicit variables in a scope. Compiler tells me that. IDE warns me when it could not infer a type of an expression though, usually because of forgotten implicit conversions. I should always keep implicits in mind and go to a function declaration or documentation every time I have a problem. IDEA does highligh expressions where implicit conversion is used. `Ctrl + Q` and `Cmd + Shift + P` help to dig into a code a bit. But when I forget implicit variables it keeps silent.

There are well known hells in programming: callback hell, DLL hell, etc. I've met the term _implicit hell_ about Scala only once on the Internet, but I can't deny it. This is the second biggest problem I have with Scala. The first one is the fact that it is hard to convince your boss using Scala:) 

_What do you think? Are implicits a problem for you?_

## More links on the topic

* [Implicit parameters](http://docs.scala-lang.org/tutorials/tour/implicit-parameters.html) in Scala doc
* [Where does Scala look for implicits](http://docs.scala-lang.org/tutorials/FAQ/finding-implicits.html)
* [An introduction to implicit arguments](http://www.drmaciver.com/2008/03/an-introduction-to-implicit-arguments/)
* [Implicit classes](http://docs.scala-lang.org/overviews/core/implicit-classes.html) in Scala doc
* [How can I chain implicit conversions?](http://docs.scala-lang.org/tutorials/FAQ/chaining-implicits.html)
