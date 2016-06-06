---
layout: post
title: Make them suffer / Actors internal state
date: 2015-10-08
comments: true
language: en
description: Dealing with concurrency and internal state of Akka actors. Make them suffer is a series of posts about Scala and Akka.
---

{% img center /images/make-them-suffer/title-1.jpg %}

Originally [actors](https://en.wikipedia.org/wiki/Actor_model) were defined in the 1973 paper by Carl Hewitt, long before Cannibal Corpse band was formed (in 1988). Later actor model have been popularized by the Erlang language. _Make them suffer_ is a series of posts where I'm gonna talk about Scala and its popular implementation of actor model – [Akka Framework](http://akka.io).

Actor model makes it easy to write concurrent code by avoiding locks and synchronizations. Actor system guarantees that each actor processes messages from its mailbox _sequentally_ and _one at a time_. In case of Akka, there is a thread pool behind the scenes, so each actor is executed on a single thread. However you should be careful anyway and follow some rules in order to write safe Akka/Scala code. Here are these rules which I've found in books and through blood and pain of my own Scala experience.

## Mutable state

{% codeblock lang:scala %}
import scala.collection._
import akka.actor._

class BrutalActor extends Actor {
  private val hammerSmashedFaces: mutable.Set[Face] = mutable.Set.empty

  def receive: Receive = {
    case Smash(face) =>
      hammerSmashedFaces += face
    case GetTotalDeaths =>
      sender ! hammerSmashedFaces.size
  }
}
{% endcodeblock %}

With this guarantee in mind you can easily use private mutable collections, `var`s and pretty much everything inside your actor instance without locks and synchronizations. It is safe to mutate collections and assign variables inside `receive` method, bacause the framework will never call it concurrently in different threads. That's why writing applications with actors is so cool. However, it is not absolutely safe and easy.

## Become/Unbecome

If you are not fine with mutable variables, for you there is another way to carry internal state inside of an actor. Lets take a look at Erlang example:

{% codeblock lang:erlang %}
blood_pool(Blood) ->
  receive
    bye ->
      io:format("Bye bye~n", []);
    {add, Gallons} ->
      blood_pool(Blood + Gallons)
    {get_blood_volume, Sender} ->
      Sender ! Blood
      blood_pool(Blood)
  end.
{% endcodeblock %}

Erlang has no mutable variable and data structures, but it has tail call optimization. Inside the `blood_pool` process there is a `receive` call, which blocks until there is at least one message in a mailbox. If you want to process just one message and quit, then simply do nothing after that. When you want to process messages constantly you need to call a process recursively (to call `receive` again and again). As a side effect of this approach you can store internal state as function arguments and change it between messages, using only immutable data structures. True funtional way.

Akka took that approach and made it even better. Akka allows you to switch behavior on the fly with `become` method. So we can rewrite our previous example:

{% codeblock lang:scala %}
import scala.collection.immutable._
import akka.actor._

class BrutalActor extends Actor {
  def destroyEverything(hammerSmashedFaces: Set[Face]): Receive = {
    case Smash(face) =>
      context become destroyEverything(hammerSmashedFaces + face)
    case GetTotalDeaths =>
      sender ! hammerSmashedFaces.size
  }

  def receive = destroyEverything(Set.empty)
}
{% endcodeblock %}

You can switch between many different behaviors and even implement a finite state machine with it (for explicit use there is Akka FSM, btw). One more feature `become` has is that it can store previous behavior in a stack. By default it replaces top behavior every time, but with `discardOld = false` option you can push item on top of a stack and then pop it with `unbecome`. Be careful and __make sure you have equal depths of `become` and `unbecome` calls__. Also __stacking behaviors too deep can cause space leaks__ (all these partial functions with correspondent closures will be referenced from a stack).

## Do not expose internal state

Usually you have only an `ActorRef` which hides an instance of `Actor` from you. And __you should never create an `Actor` instance manually__. There are several reasons behind that, such as:

* A user works with local and remote actors in the same fashion
* Framework can handle actors restarts transparently for a user
* Custom routing can be performed behind one `ActorRef`
* A user can not directly call methods on an `Actor` instance

The latter safes us from mutating actor's state in different threads concurrently. But there is one more way to expose state outside of an actor: by sending or recieving mutable objects as messages. So here is one more rule: __send only case classes and immutable collections between actors!__ Frankly speaking, this rule is not only for Akka. Using as much immutable data structures and `val`s in Scala as possible helps you write code faster and debug it easier. 

## Caution hot

I wouldn't have written this post if programming had been so easy. Even though you do not expose actor's internal state anymore, it is still possible to introduce concurrency and mutate state from different threads. How?

Lets say we have two actors. First one performs long computation, for example address geocoding:

{% codeblock lang:scala %}
object AddressResolverActor {
  case class ResolveCoordinates(address: Address)
}

class AddressResolverActor(geocoding: Geocoding) extends Actor {
  import AddressResolverActor._

  def receive = {
    case ResolveCoordinates(address) =>
      sender ! geocoding.findLatLng(address)
  }
}
{% endcodeblock %}

And another one needs a result of this long computation to change its state:

{% codeblock lang:scala %}
import akka.pattern.{ask, pipe}

object ManiacActor {
  case class Kill(name: String, address: Address)
  case class AddressResolved(name: String, address: Address, coordinates: LatLng)
}

class ManiacActor(addressResolver: ActorRef) extends Actor {
  import ManiacActor._
  import AddressResolverActor._

  private val victims: mutable.Queue[Victim] = mutable.Queue.empty

  def receive = {
    case Kill(name, address) => {
      val addressResolvedFuture = (addressResolver ? ResolveCoordinates(address)).
        mapTo[LatLng].
        map(coordinates => AddressResolved(name, address, coordinates))

      addressResolvedFuture pipeTo self
    }

    case AddressResolved(name, address, coordinates) =>
      victims += Victim(name, address, coordinates)
  }
}
{% endcodeblock %}

Ask pattern is a nice tool which simply gives you a `Future` with an answer when you `ask` any actor to return something. It is cool yet dangerous. Behind the scenes it creates temporary actor and wait to receive just one message with many tricky consequences of that. I will cover it later in another post. For now we just need to know that lambda in `map` will be executed somewhere on another thread. It closes over upper scope so we can use, for example, variables `name` and `address`, which is extremely convinient. However it also closes over instnance's private variables. And poor you if you are gonna change actor's state from this lambda! This is a tricky part. To avoid problems with concurrency here, follow a simple rule: __`pipe` futures to `self` and change internal state only in `receive` function directly__.

_Now you know how to handle actors internal state and avoid concurrency problems in Akka. In the next posts I will cover more tricky parts of it. Comments are welcome! Happy hAkking!;)_