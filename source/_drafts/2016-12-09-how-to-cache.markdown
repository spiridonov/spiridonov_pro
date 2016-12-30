---
layout: post
title: How to cache
date: 2016-12-09
comments: true
language: en
published: false
description: 
---

{% img center /images/how-to-cache/title.jpg %}

_In computing, a cache is a hardware or software component that stores data so future requests for that data can be served faster; the data stored in a cache might be the result of an earlier computation, or the duplicate of data stored elsewhere. – Wikipedia_



Caching is a pain. Especially partial cache. One does not simply return cached response. There are such things as authentication and authorization. Any level of magic you try to introduce to make your code cleaner actually affects performance. Cache is meant to save time. If you retrieve an object from a storage and have to look at its `cache_key` you save nothing, because you've already retrieved it from the storage (especially when huge `.preload()` condition is applied). Making it really fast and smart demands you to implement read-cached and read-directly branches manually. And in case of partial cache – to implement them on per-array-item/per-tree-child level.