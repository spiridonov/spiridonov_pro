---
layout: post
title: Reading / Actors in Scala
date: 2014-02-21
comments: true
language: en
---

{% img center /images/actors-in-scala/cover.jpg %}

I knew about actors since I started learning Erlang. Now I'm playing around Scala and Akka framework, which was inspired mostly by Erlang actors.

There is one simple rule for actors: do not expose internal actors state. But actually it's not so trivial to build a large (even medium) actor system. I was looking for _design patterns_ and _best practices_ for actor systems. How to manage dependencies (both supervising and message passing)? How to build a good protocol (set of possible messages)? How to change internal state and behavior properly (_become()_ in akka)? And so forth...

So I found __Actors in Scala__ book. Getting ahead of myself: I haven't got what I was looking for:) This book starts with covering basics of concurrency. It seems obvious, but anyway I've got several new points for me. Main part describes Scala Actors API, which is pretty much the same as Akka API. BTW there is a letter from Martin saying that Akka will probably be included into Scala standard library in future releases instead of Scala Actors. And finally there are couple of chapters covering Akka API.

This book is a good introduction into Scala actors, especially if you are new to the idea of actors. It has't answered my questions about design of large systems. Maybe I will find them in Erlang/OTP bibles. Erlangers, what can you recommend?