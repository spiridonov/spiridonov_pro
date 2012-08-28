---
layout: post
title: Ruby gotchas. Part 1
date: 2012-08-25 15:56
comments: true
language: en
---

{% img center /images/ruby-gotchas/wtf.jpg %}

## Automatic class loading gotcha

There are several Rails models. Of course each class is located in separate file.

{% codeblock lang:ruby %}
class Human
  #...
end

class Human::Head
  #...
end

class AlabamaMan < Human
  #...
end

class AlabamaMan::Head < Human::Head
  #...
end

class MonicaBellucci < Human
  #...
end

class MonicaBellucci::Head < Human::Head
  #...
end
{% endcodeblock %}

It looks OK. Yes? But there is one hidden problem, I wouldn`t write an article
into my blog if there was no one:) Lets go to Rails console:

    irb(main):001:0> Human
    => Human
    irb(main):002:0> Human::Head
    => Human::Head
    irb(main):003:0> AlabamaMan::Head
    => Human::Head

Wtf!? Reopen console and try again:

    irb(main):001:0> AlabamaMan::Head
    => AlabamaMan::Head
    irb(main):002:0> MonicaBellucci::Head
    => Human::Head
    irb(main):003:0> Human::Head
    => Human::Head

The problem occurs only in development Rails environment because of automatic class loading. When we ask for `Human::Head` Ruby tries to find constant `Head` in `Human` module. It doesn\`t find and then tries to load class `Human::Head`. Then we ask for `AlabamaMan::Head`. Ruby doesn\`t find constant `AlabamaMan`, loads correspondent class and then tries to find `Head` there. Of course there is no `Head` yet and Ruby tries to find it in parent class. Ooooopss!

The same shit happens in the second time. `AlabamaMan::Head` loads:

* `AlabamaMan` - because there is no `AlabamaMan`
* `Human` - as the parent of `AlabamaMan`
* `AlabamaMan::Head` - because there is no `Head` neither in `AlabamaMan` nor in `Human`
* `Human::Head` - as the parent of `AlabamaMan::Head`

And `MonicaBellucci::Head` returns parents `Human::Head` for the same reason...

This doesn\`t happen in production environment and with files required manually via `require 'somefile'`.

## Constant name resolution gotcha

{% codeblock lang:ruby %}
A = 1

module Foo
  A = 2

  class Bar
    def self.method1
      A
    end
  end
end

class Foo::Bar
  def self.method2
    A
  end
end

module Foo
  class Bar
    def self.method3
      A
    end
  end
end
{% endcodeblock %}

Lets check it in Rails console:

    irb(main):001:0> Foo::Bar.method1
    => 2
    irb(main):002:0> Foo::Bar.method2
    => 1
    irb(main):003:0> Foo::Bar.method3
    => 2

There is a difference between `Foo::Bar` and `module Foo ... class Bar`, remember that! When we declare Bar inside Foo module, Bar gets lexical scope of Foo.

##Related links

* [Pat Shaughnessy - Objects, Classes and Modules](http://patshaughnessy.net/2012/7/26/objects-classes-and-modules)
* [Overriding instance method with module](http://shime.github.com/blog/2012/08/06/overriding-instance-method-with-module-method/)
* [Module.nesting and constant name resolution in Ruby](http://coderrr.wordpress.com/2008/03/11/constant-name-resolution-in-ruby/)

