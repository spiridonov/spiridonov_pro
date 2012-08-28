---
layout: post
title: Rubinius and Rubymine
date: 2012-08-28 15:57
comments: true
language: en
published: false
---

## Installing Rubinius

Installing rbx-2.0.0-dev with Ruby 1.9 support using rbenv can be a tad tricky. This is what I did to get up and running, you'll need another version of ruby already installed as well as rake.

**The basic outline:**

- Clone Rubinius HEAD from github
- Configure installation for rbenv and 1.9 support
- Install Rubinius
- Configure your $PATH to use Rubinius gems
- Start using Rubinius

**[OPTIONAL] You may need to install libyaml, otherwise you get a psych warning**

    $ brew install libyaml

**Get the latest HEAD for rbx-2.0.0-dev**

    $ git clone https://github.com/rubinius/rubinius.git

**Configure Rubinius for compatibility with 1.9 and install it**

    $ cd rubinius
    $ ./configure --prefix=~/.rbenv/versions/rbx-2.0.0-dev --enable-version=1.8,1.9 --default-version=1.9
    $ rake install

**Rubinius keeps its gem binaries in a different location than other rubies, so you'll need to add the proper bin directory to your path for any gem commands to work. I added the following to my ZSH setup**

    export RBX_ROOT=$HOME/.rbenv/versions/rbx-2.0.0-dev

**And then in my PATH, I included**

    $RBX_ROOT/gems/1.9/bin

Now Rubinius is available via rbenv:

    $ rbenv global rbx-2.0.0-dev

## 
