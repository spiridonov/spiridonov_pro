---
layout: post
title: Rubinius 2.0, rbenv and Rubymine
date: 2012-08-28 15:57
comments: true
language: en
---

It\`s enough easy to install Rubinius 2.0.0-dev with Ruby 1.9 support. But you\`ll have some problems with rbenv and Rubymine as well:)

## Installing Rubinius 2.0

You'll need another version of ruby already installed as well as rake for installing Rubinius 2.0. Don\`t use another version of Rubinius for installing this one:)

Also libyaml must be installed. I use homebrew for this:

    $ brew install libyaml

Get the latest HEAD for rbx-2.0.0-dev and install it:

    $ git clone https://github.com/rubinius/rubinius.git
    $ cd rubinius
    $ ./configure --prefix=~/.rbenv/versions/rbx-2.0.0-dev --enable-version=1.8,1.9 --default-version=1.9
    $ rake install

Rubinius stores gem\`s bin files in distinctive folder, so rbenv doesn\`t correctly work with them. Fortunately, there is a [plugin](https://github.com/collinschaafsma/rbenv-rbx_2.0.0-dev_fix) for fixing that.

    $ mkdir -p ~/.rbenv/plugins
    $ cd ~/.rbenv/plugins
    $ git clone https://github.com/collinschaafsma/rbenv-rbx_2.0.0-dev_fix.git

Now Rubinius is available via rbenv:

    $ rbenv global rbx-2.0.0-dev

## Rubymine


