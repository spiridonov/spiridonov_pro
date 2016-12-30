---
layout: post
title: akka-ask-pattern
date: 2015-12-26
comments: true
published: false
language: en
---

{% img center /images/make-them-suffer/title-3.jpg %}

_Make them suffer_ is a series of posts about Scala and Akka. [Previously](/2015/10/14/scala-implicit-hell) we discussed how to handle dependencies in your code in general and what is the Scala way to do that (implicit parameters and implicit conversions). Today I want to tell you about two-way communication between actors in general and Akka's ask pattern in particular.

## Sender

Lets take a look at two different cases of working with sender's `ActorRef`.

__Any king of subscription.__ One actor is a _listener_ of events emitted from another actor _subscriber_. 

{% codeblock lang:scala %}
class Actor extends Actor {
  private val hammerSmashedFaces: mutable.Set[Face] = mutable.Set.empty

  def receive: Receive = {
    case Smash(face) =>
      hammerSmashedFaces += face
    case GetTotalDeaths =>
      sender ! hammerSmashedFaces.size
  }
}
{% endcodeblock %}

callback vs monadic



pipe to

extra pattern


From Akka docs:

"There are performance implications of using ask since something needs to keep track of when it times out, there needs to be something that bridges a Promise into an ActorRef and it also needs to be reachable through remoting. So always prefer tell for performance, and only ask if you must."
But sometimes you want to send a message from outside of an actor in which case you can use ask. Using ask will guarantee that you get a response within the specified timeout and sometimes that's what you want. However, when you use ask pattern you should ask yourself a question whether you could just use Futures instead.

There is a place for ask but it should have very limited use due to the aforementioned reasons.

You don't have to use actor per request. Some actors are meant to be long lived and some not. If an actor performs a potentially dangerous or blocking operation you might want to create one per request. Whatever fits your application logic.




val r1 = myFooRequester.fooResult(request1)
val r2 = myFooRequester.fooResult(request2)
for {
  result1 <- r1
  result2 <- r2
} yield (combination(result1, result2))
A second benefit is easy type safety, though of course that can also be accomplished via typed actors.

Side note: For those unfamiliar with Akka futures, one might ask why I used this convention. Why didn't I simply write it like this?

for {
  result1 <- myFooRequester.fooResult(request1)
  result2 <- myFooRequester.fooResult(request2)
} yield (combination(result1, result2))
The answer is that the former will run concurrently, while the latter will only run serially. The latter case is equivalent to:

myFooRequester.fooResult(request1).flatMap( result1 =>
  myFooRequester.fooResult(request2).flatMap( result2 =>
    combination(result1, result2)
  )
)