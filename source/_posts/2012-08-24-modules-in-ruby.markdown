---
layout: post
title: "Modules and Classes in Ruby"
date: 2012-08-25 15:56
comments: true
language: en
published: false
---

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
{% endcodeblock %}

It looks ok. Yes? But there is one hidden problem. I wouldn`t write an article
into my blog if there was no problem:)

##Related links

* [Pat Shaughnessy - Objects, Classes and Modules](http://patshaughnessy.net/2012/7/26/objects-classes-and-modules)
* [Overriding instance method with module](http://shime.github.com/blog/2012/08/06/overriding-instance-method-with-module-method/)
* [RubyDoc 1.9.3 on Modules](http://www.ruby-doc.org/core-1.9.3/Module.html)