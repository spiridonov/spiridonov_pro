---
layout: page
title: Pet projects
language: en
---

Small funny and open source projects I’ve created.

* * *

## Source of Tits

{% img left /images/projects/sourceoftits.jpg %}

Chrome extension that allows you to post images directly to Twitter with only one click. I wrote it in order to share best tits with my friends:) All images go through FIFO queue in Chrome\`s memory. The queue is processed by worker every N minutes. I implemented Twitter\`s OAuth on JavaScript without any 3rd party libraries. So you can use this code if you want simple lightweight Twitter integration. 

[Blog](http://spiridonov.pro/2012/01/06/tits/) |
[GitHub](https://github.com/spiridonov/sourceoftits) |
[Twitter](https://twitter.com/SourceOfTits)  

* * *
  
## Source of Tits 2

{% img left /images/projects/sourceoftits2.jpg %}

This Rails application doesn\`t have cons of Chrome version. Now it doesn\`t depend on my macbook and my internet connection because it is deployed on Amazon EC2. Chrome extension became tiny and now it only sends link to the server. Database has all published, rejected and pending images, so it\`s possible now to find duplicates and similarities. There is also an admin interface for managing queues and moderation new images.

[Blog](http://spiridonov.pro/2012/06/20/tits2/) |
[GitHub](https://github.com/spiridonov/sourceoftits2) |
[Twitter](https://twitter.com/SourceOfTits)

