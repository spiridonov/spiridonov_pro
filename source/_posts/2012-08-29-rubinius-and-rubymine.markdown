---
layout: post
title: Rubinius 2.0, rbenv and RubyMine
date: 2012-08-29 15:57
comments: true
language: en
published: false
---

...It was sunny Friday\`s morning. My friend and I drank coffee and decided to try on Rubinius 2.0.0-dev. We hoped it would be enough easy to install it. But we didn\`t expect it to have some problems with rbenv and RubyMine as well:)

## Installing Rubinius 2.0

You'll need another version of ruby already installed as well as rake for installing Rubinius 2.0. Don\`t use another version of Rubinius for installing this one:)

Also libyaml must be installed. I use homebrew for doing this:

    $ brew install libyaml

Get the latest HEAD for rbx-2.0.0-dev and install it:

    $ git clone https://github.com/rubinius/rubinius.git
    $ cd rubinius
    $ ./configure --prefix=~/.rbenv/versions/rbx-2.0.0-dev --enable-version=1.8,1.9 --default-version=1.9
    $ rake install

Rubinius stores gem\`s bin files in distinctive folder, so rbenv doesn\`t correctly work with them. Fortunately, a [plugin](https://github.com/collinschaafsma/rbenv-rbx_2.0.0-dev_fix) exists for fixing that.

    $ mkdir -p ~/.rbenv/plugins
    $ cd ~/.rbenv/plugins
    $ git clone https://github.com/collinschaafsma/rbenv-rbx_2.0.0-dev_fix.git

Now Rubinius is available via rbenv:

    $ rbenv shell rbx-2.0.0-dev
    $ ruby -v
    rubinius 2.0.0dev (1.9.3 72207d94 yyyy-mm-dd JI) [x86_64-apple-darwin12.1.0]

## RubyMine

We had just installed Rubinius and went to _Settings -> Ruby SDK and Gems_ (RubyMine version 4.5.2). Unfortunately it couldn\`t find RubyGems for rbx-2.0.0-dev. It looked strange, so we went to console to make sure:

    $ rbenv shell rbx-2.0.0-dev
    $ gem list
    *** LOCAL GEMS ***
    actionmailer (3.2.8)
    actionpack (3.2.8)
    activemodel (3.2.8)
    ...

OK. Lets look at Rubinius folder:

    $ cd ~/.rbenv/versions/rbx-2.0.0-dev/bin
    $ ls -la
    total 32840
    drwxr-xr-x  10 stanislav  staff       340 Aug 28 18:41 .
    drwxr-xr-x   8 stanislav  staff       272 Aug 28 18:41 ..
    lrwxr-xr-x   1 stanislav  staff         3 Aug 28 18:41 gem -> rbx
    lrwxr-xr-x   1 stanislav  staff         3 Aug 28 18:41 irb -> rbx
    lrwxr-xr-x   1 stanislav  staff         3 Aug 28 18:41 rake -> rbx
    -rwxr-xr-x   1 stanislav  staff  16781972 Aug 28 18:41 rbx
    lrwxr-xr-x   1 stanislav  staff         3 Aug 28 18:41 rdoc -> rbx
    lrwxr-xr-x   1 stanislav  staff         3 Aug 28 18:41 ri -> rbx
    lrwxr-xr-x   1 stanislav  staff         3 Aug 28 18:41 ruby -> rbx
    -rwxr-xr-x   1 stanislav  staff       297 Aug 28 18:41 testrb

How interesting! There are one God File `rbx` and many symbolic links to it. `argv` contains the actual arguments, starting with index 1. Index 0 is the program name. So Rubinius looks at `argv[0]` and determines what we want it to be. 

