---
layout: post
title: My web app is not just a blog
date: 2016-12-08
comments: true
language: en
description: Dealing with complexity, pain and tears of modern development and real life projects.
---

{% img center /images/my-app-is-not-a-blog/title.jpg %}

My current project has been under active development for more than one year so far. It is in production already. Me and dozen of other developers (total team size is 30+) have been writing code for it constantly and patiently. And we still have a lot of stuff to do. So under no circumstances will I say this project is simple and small. It is not _yet another blog app_. Considering all my experience (and all projects I've done) every more or less serious application is orders of magnitude more complicated that a notorious blog. Frankly speaking, these blog apps only exist on pages of books and articles as examples of libraries and frameworks. _Post has many Comments, Comment belongs to Author, bla bla_, you know this... Even real blog applications are much more complicated than those blogs from books. And here I want to tell you why all those approaches which look sexy and promising in small examples actually do not work on real life projects.

_Note:_  
_Even though we use Ruby as a language for our projects and ActiveRecord as an ORM, all my thoughts below are language- and storage- independent. These problems occur in all object-oriented languages and with all ORMs._

## Retrieving data from storage

The goal is simple: to isolate our storage layer from business layer. Sounds reasonable, right? That's why all these fancy ORMs exist.

Some frameworks have criteria- (or specification-) based repositories. To retrieve data one must construct a criteria object and pass it to a repository, repository will convert this criteria to SQL query and get data. The idea is to abstract our code from pure SQL. But in fact these criteria objects do not isolate anything at all.

Look at Hibernate. Its [criteria language](https://docs.jboss.org/hibernate/orm/3.3/reference/en/html/querycriteria.html) is sophisticated and rich. Rich enough to be mapped to another rich and expressive language such as SQL (although partially). In fact it looks exactly the same as SQL, but implemented as Java classes and methods. So where is an abstraction? The only abstraction you get here is an independance from particular SQL server implementation. But chances are you will never migrate from Oracle to Postgres or from MySQL to MS SQL Server during project's lifetime. Even if you did it would not be as simple as changing connection string from one database to another.

You always have to choose between flexibility and performance. Hibernate criterias can be mapped to SQL, so database indicies are available for speeding up queryies (if ORM constructs appropriate query). Here is an [example](http://www.codeproject.com/Articles/670115/Specification-pattern-in-Csharp) of flexible specification. Method `IsSatisfiedBy()` is applied to each element, so no matter what specification you've got it always will work as O(N) (full scan).

In ActiveRecord a query is constructed by chaining clauses which are very similar to SQL clauses: `.where()`, `.order()`, `.joins()`. You might think that a hash passed to `.where()` can be a criteria object. Unfortunately it is true only in simple cases. You might also need to preload some associations, join table or query from recursive CTE (the worst case ever), which is not represented as a criteria object anymore. Moreover for complex queryies this chains become an ugly mix of SQL parts (CTEs, left joins, `like`s, unios, functions, etc) and ActiveRecord/Arel parts.

Another idea that one can seamlessly replace a repository with another implemenation (for example replace DB repository to in-memory one) is also a bullshit. Imagine the amount of code and magic that is required to convert abstract criteria object to either SQL or some in-memory manipulation with arrays or trees. The same domain can be implemented in completely different ways in relational databases, graph databases or with local in-memory data structures. Either these criterias will be too limited (to subset all of them) or their implementation will be too complex (to superset all of them).

Ok, if it is not possible to abstract our queryies and criterias, we can just hide them behind a method or a class. These classes are known as _Query Objects_ and methods belong to another design pattern – _Repository_. Repositories at first sight look sexy. All query logic can be hidden behind `.by_id(id)`, `.for_user(user_id)`, `.active_since(date)` methods. But remember that we don't create yet another simple blog app. In real life projects domain logic is so complex, that repositories classes quickly get bloated with dozens of methods, because you need to get a user `.by_id()`, `.by_email()`, `.all_admins()`, `.all_active()`, `.all_banned()`, `.all_assigned_to_location()`, `.all_subordinates_of()`, etc, with or without preloads, and so long and so forth... Multiply that by the number of models (150+ in our case). The same problem you get with Query Objects, but instead of zillions of methods you get zillions of single-method classes. Naming is also a problem here. The more complicated query you try to hide behind a method (or class), the longer name this method gets (because, of course, methods/classes should be self-describing).

Clients always want to see some reports, a lot of them. Reports are not just `index` pages of models, they usually include some aggregations, combinations of several models and computations. To get data faster you construct queryies that use joins widely (which is the right way of doing queryies in SQL, of course) and mix more columns into your result set. With ActiveRecord you always need to start a chain with a model class. But this result is not your domain class anymore, it is a strong mix of several domain models seasoned with counters and flags. You can not rely on a class anymore because depending on a query there are different sets of columns. It is easy to get into this trap. Declaring a new class for each query is absolutely pointless since ActiveRecord models do not contain column declarations inside a class itself.

## Lights out

Enough hate for today, I've got to work. There are still a lot of approaches and buzzwords I haven't covered yet. So I leave them for the future posts. For now you are welcome into comments section below! 
