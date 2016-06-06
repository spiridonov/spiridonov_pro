---
layout: post
title: My app is not just a blog
date: 2016-04-26
comments: true
language: en
published: false
description: Dealing with complexity, pain and tears of modern development and real life projects.
---

{% img center /images/my-app-is-not-a-blog/title.jpg %}

My current project has been under active development for about 10 months so far. Recently it has gone to production for first wave clients successfully. Me and dozen of other back-end developers (total team size is 20+) have been writing code for it constantly and patiently. And we still have a lot of stuff to do. So under no circumstances will I say this project is simple and small. It is not _yet another blog app_. Considering all my experience (and all projects I've done) every more or less serious application is orders of magnitude more complicated that a notorious blog. Frankly speaking, these blogs only exist on pages of books and articles as examples of libraries and frameworks. _Post has many Comments, Comment belongs to Author, bla bla_, you know this... And today I want to tell you why all those approaches which look sexy and promising in small examples actually do not work on real life projects.

_Note:_  
_Even though we use Ruby as a language for this project and ActiveRecord as an ORM, all my thoughts below are language- and storage- independent. These problems occur in all object-oriented languages and with all ORMs._

## Retrieving data from storage

The goal is simple: to isolate our storage layer from business layer. Sounds reasonable, right? That's why all these fancy ORMs exist.

Some frameworks have criteria- (or specification-) based repositories. To retrieve data one must construct a criteria object and pass it to a repository, repository will convert this criteria to SQL query and get data. The idea is to abstract our code from pure SQL. But in fact these criteria objects do not isolate anything at all.

Look at Hibernate. Its [criteria language](https://docs.jboss.org/hibernate/orm/3.3/reference/en/html/querycriteria.html) is sophisticated and rich. Rich enough to be mapped to another rich and expressive language such as SQL (although partially). In fact it looks exactly the same as SQL, but implemented as Java classes and methods. So where is an abstraction? The only abstraction you get here is an independance from particular SQL server implementation. But chances are you will never migrate from Oracle to Postgres or from MySQL to MS SQL Server during project's lifetime.

You always have to choose between flexibility and performance. Hibernate criterias can be mapped to SQL, so database indicies are available for speeding up queries. Here is an [example](http://www.codeproject.com/Articles/670115/Specification-pattern-in-Csharp) of flexible specification. 

In ActiveRecord a query is constructed by chaining clauses which are very similar to SQL clauses: `.where()`, `.order()`, `.joins()`. You might think that a hash passed to `.where()` can be a criteria object. Unfortunately it is true only in simple cases. You might also need to preload some associations, join table or query from recursive CTE (the worst case ever), which is not represented as a criteria object anymore. Moreover for complex queries this chains become an ugly mix of SQL parts (CTEs, left joins, `like`s, functions, etc) and ActiveRecord parts.

Another idea that one can seamlessly replace a repository with another implemenation (for example replace DB repository to in-memory one) is also a bullshit. Imagine the amount of code and magic that is required to convert abstract criteria object to either SQL or some in-memory manipulation with arrays or trees. The same domain can be implemented in completely different ways in relational databases, graph databases or with local in-memory data structures. Either these criterias will be too limited or their implementation will be too complex.

Ok, if it is not possible to abstract our queries and criterias, we can just hide them behind a method or a class. These classes are known as _Query Objects_ and methods belong to another design pattern – _Repository_. [Repositories](https://github.com/rom-rb/rom-repository#mapping--structs) at first sight look sexy. All query logic can be hidden behind `.by_id(id)`, `.for_user(user_id)`, `.active_since(date)` methods. But remember that we don't create yet another simple blog app. In real life projects domain logic is so complex, that repositories classes quickly get bloated with dozens of methods, because you need to get a user `.by_id()`, `.by_email()`, `.all_admins()`, `.all_active()`, `.all_banned()`, `.all_assigned_to_location()`, `.all_subordinates_of()`, with or without preloads, and so long and so forth... Multiply that by the number of models (150+ in our case). The same problem you get with Query Objects, but instead of zillions of methods you get zillions of single-method classes. Naming is also a problem here. The more complicated query you try to hide behind a method (or class), the longer name this method gets (because, of course, methods/classes should be self-describing).

## Presenting data on a screen

We always carefully model our domains, draw relation diagrams, brainstorm for naming fields and classes. No matter which ORM we use we create classes to represent our domain. When all classes and relations are done, we can start working on other parts. This is how things are usually done, right?

All these simple blog examples assume that an object you get from a database is displayed on a screen as-is and updated from an edit screen back into a database as-is as well. This is never the case. In real life project a screen for an entity never match its internal representation, both for updating and displaying. To handle updating different forms of a single entity _Form Objects_ were invented, but this is the whole another story. 

A set of columns in a list of orders is slightly different than a set of fields in an `Order` class. Moreover two lists of orders (for client and manager) are also different. That doesn't mean that your domain design is wrong. Different forms of displaying data come from complex domain, client's requirements and existing established business process. You might say that my example with two lists for client and manager can be solved with two bounded contexts, but I will give you even more examples of tree-like audit reports and forms made out of standard forms with a little bit of per-client customization and powered by milti-language support where the presentation depends on a position of current user in a company's hierarchy.

To get data faster you construct queryies that use joins widely (which is the right way of doing queries in SQL, of course) and mix more columns into your result set. With ActiveRecord you always need to start a chain with a model class. But this result is not your domain class anymore, it is a strong mix of several domain models seasoned with counters and flags. You can not rely on a class anymore because depending on a query there are different sets of columns. Declaring a new class for each query is absolutely pointless since ActiveRecord models do not contain column declarations inside a class itself.

Caching is also a pain. Especially partial cache. One does not simply return cached response. There are such things as authentication and authorization. Any level of magic you try to introduce to make your code cleaner actually affects performance. Cache is meant to save time. If you retrieve an object from a storage and have to look at its `cache_key` you save nothing, because you've already retrieved it from the storage (especially when huge `.preload()` condition is applied). Making it really fast and smart demands you to implement read-cached and read-directly branches manually. And in case of partial cache – to implement them on per-array-item/per-tree-child level.

## This is not the end

Enough hate for today, I've got to work. There are still a lot of approaches and buzzwords I haven't covered here: so called REST API, microservices, form objects, service objects, CQRS, etc. Next time I have the right mood for that I'll cover them as well. For now you are welcome into comments section below! 
