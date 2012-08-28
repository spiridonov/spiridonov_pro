---
layout: post
title: "I migrated to Octopress before it was mainstream"
date: 2012-08-23 08:01
comments: true
language: en
---

Actually not. There are already hundreds of people who have migrated from bulky Wordpress / Blogger / etc to static blog engines. You can find most of them [here](https://github.com/imathis/octopress/wiki/Octopress-Sites). But in contrast with millions of Wordpress users static blogs are not mainstream yet.

Pros of this migrations for me are:

* **Octopress is very fast.** You write markdown pages and then Jekyll generates static HTML pages. So you don\`t need databases or even any programming languages on server\`s side.
* **Cheaper or free hosting.** It\`s easy to find free hosting for static HTML pages. I deploy on Amazon S3. Actually it\`s not free, but my total cost is only a few cents.
* **It\`s funny!** I can write Ruby, Markdown, SASS... I can fix or tweak everything. I can use Git for blog posts. Hacker\`s way:)

## Configuring and customizing

Customizing of theme took almost all my time. I took several open source themes for Octopress, mixed them and customized layout, header and syntax highlighting. Configuring and customizing the rest code was easy enough and took less time.

As you may know I had a Wordpress blog before that and there is a easy way to migrate from it to Octopress. All you need is to convert your Wordpress .xml import file with ExitWP tool. I got some problems with original ExitWP, so then I tried chitsaou`s fork.

**Remember:** This is a framework for hackers! So you always will tweak it, fix it, deploy pages after each change and write scripts for that:) But it\`s cool! I like it:)

I copied ExitWP result from `build/jekyll/spiridonov.pro` to my Octopress folder, ran `rake generate` and then I got a problem during generation (yes, again):

    Configuration from /Users/stanislav/development/spiridonov/spiridonov_pro/_config.yml
    Building site: source -> public
    /Users/stanislav/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/jekyll-0.11.2/lib/jekyll/convertible.rb:29:in `read_yaml': invalid byte sequence in US-ASCII (ArgumentError)

The problem is that my locale settings are wrong. It can be fixed with `export` locale environment variables. I don\`t want to do it every time from shell, so I just put this code into my `Rakefile`:

{% codeblock lang:ruby %}
ENV['LC_CTYPE'] = 'ru_RU.UTF-8'
ENV['LANG'] = 'ru_RU.UTF-8'
{% endcodeblock %}

After I got tons of converted markdown files I had to fix them all. Almost all defects were about images, but there were also layout and links defects.

There are also a lot of small fixes I made in my code. I don\`t want to describe all of them here. You can find full sources on my GitHub page, if you want.

## Dual Language

In order to practice language I decided to write articles in English. But what should I do with two-years archive in Russian? At first I decided to delete it and start new blog and new life:) But finally I decided to delete worse half of it and keep the rest in a separate folder.

Octopress is very flexible! I can make several index pages (actually I want they to look like blog archive), one for Russian articles and one for English. The English one will be the root index page. I put `language: en` option into YAML config of each page/post and then made index pages, navigation and footer sensitive to this `language` option.

It would also be cool to change language of Disqus comments according to post\`s language. I found one way to do this, though it doesn\`t work for Disqus 2012. So I\`m still looking for better approach. Put this into `source/_includes/disqus.html`:

{% codeblock lang:js %}{% raw %}
var disqus_config = function () { 
  {% if page.language == 'ru' %}
  this.language = "ru";
  {% else %}
  this.language = "en";
  {% endif %}
}; 
{% endraw %}{% endcodeblock %}

## Related links

* [Octopress official site](http://octopress.org/)
* [Octopress engine on GitHub](https://github.com/imathis/octopress)
* [My blog`s sources on GitHub](https://github.com/spiridonov/spiridonov_pro)
* [Original ExitWP by thomasf](https://github.com/thomasf/exitwp)
* [Fork of ExitWP by chitsaou with some fixes](https://github.com/chitsaou/exitwp)
* [Hosting an Octopress Blog on Amazon S3](http://www.ianwootten.co.uk/2011/09/09/hosting-an-octopress-blog-on-amazon-s3)
* [Quick Tip for Easily Deploying Octopress Blog on Amazon S3](http://www.jerome-bernard.com/blog/2011/08/20/quick-tip-for-easily-deploying-octopress-blog-on-amazon-s3/)
* [Markdown by John Gruber](http://daringfireball.net/projects/markdown/basics)

