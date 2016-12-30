---
layout: post
title: Brain damage
date: 2016-12-09
comments: true
language: en
published: false
description: 
---

{% img center /images/how-to-cache/title.jpg %}

I've been working with Rails for 5 years. This is enough time to change your way of thinking. Or I would say – __to damage__ it. I clearly see how I changed, how my colleagues changed, how people in the community changed. You need to be strong enough and self-critic enough to assess the damage in yourself.

__Use it or lose it.__ This is not only about sports and muscles. This simple rule can be also applied to any skills. We all came to web dev with different background: bloody enterprise Java development, PHP, Delphi, dotNET, C++... 


## Is there a gem for X?

## Does language X have an ORM?



## Concurrency

Writing concurrency code is hard and it has always been. However, while some people try to improve tools and invent approaches to make writing concurrent programs easier, we just do not write them at all. We've got one language, suitable only for writing singlethreaded programs, let's be honest, another language fundamentally based on a simple event loop, a singlethreaded web server, etc. This is a step back. I used to write multithreaded programs in Delphi, C, C#, Java before that. WinAPI and pthread, mutexes and semaphores, critical sections and events, schedulers and pools, race conditions and priority inversions... Avoiding multithreaded programming does not save from concurrenty pitfalls. If you do not understand these things you can easily introduce race conditions via database or redis. 

Use it or lose it. Those skills are lost. RIP.

## Performance

