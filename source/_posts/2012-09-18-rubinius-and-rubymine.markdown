---
layout: post
title: Rubinius 2.0, rbenv and RubyMine
date: 2012-09-18 15:57
comments: true
language: en
---

...It was sunny Friday\`s morning. My friend and I drank coffee and decided to take a look at Rubinius 2.0.0-dev. We hoped it would be enough easy to install. But we didn\`t expect it to have some problems with rbenv and RubyMine as well:)

Rubinius is an alternative Ruby implementation. In Rubinius as much of Ruby as possible is implemented in Ruby language itself. So it\`s very helpful and interesting to see how some parts of Ruby core work. And it\`s more interesting than digging into C code of MRI (but of course it\`s helpful in some cases too). Another thing you should know - Rubinius is a thread-safe interpreter. So you may use Celluloid or Puma server with full support of threads.

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

This is a long story... :)

We had just installed Rubinius and went to _Settings -> Ruby SDK and Gems_ (RubyMine version 4.5.2). Unfortunately it couldn\`t find RubyGems for rbx-2.0.0-dev. It looked strange, so we went to console to make sure:

    $ rbenv shell rbx-2.0.0-dev
    $ gem list
    *** LOCAL GEMS ***
    actionmailer (3.2.8)
    actionpack (3.2.8)
    activemodel (3.2.8)
    ...

OK. Let\`s have look at Rubinius folder:

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

How interesting! There are one God File `rbx` and many symbolic links to it. As you may know, `argv` contains the actual arguments, starting with index 1. Index 0 is the program name. So Rubinius looks at `argv[0]` and determines what we want it to be. Well, it\`s a good idea.

We made separate folder for experiments:

    cd /tmp
    mkdir rbx
    cd rbx
    ln -s /Users/stanislav/.rbenv/versions/rbx-2.0.0-dev/bin/rbx ruby

Then we went to _Settings -> Ruby SDK and Gems_ again and saw that RubyMine resolved symbolic links. So we changed symlink to hardlink:)

    rm ruby
    ln /Users/stanislav/.rbenv/versions/rbx-2.0.0-dev/bin/rbx ruby

I decided to watch how RubyMine ran `gem` command and created simple `gem` file which sniffs all commandline arguments of each call. I probably could use `fs_usage` or another monitoring tool, but I didn\`n want that. Looking ahead, it was a right solution;)

{% codeblock lang:ruby %}
#!/Users/stanislav/.rbenv/versions/1.9.3-p194/bin/ruby

File.open('log.txt', 'a') do |f|
  f.write("#{ARGV*', '}\n")
end
{% endcodeblock %}

Run RubyMine and watch at `log.txt`:

    environment, gempath

Hm, seems legit. Maybe we should sniff also `ruby` calls? Just copy and rename `gem` file:

    script8027539471226326548.rb
    script5012912298001198018.rb
    -v
    script8063238159134301426.rb
    -v
    script8764279234205520073.rb
    -v
    script3430463985826171909.rb
    script2853497228306159189.rb
    -x, /private/tmp/rbx/gem, environment, gempath
    -x, /private/tmp/rbx/gem, environment, gempath
    -x, /private/tmp/rbx/gem, environment, gempath
    -x, /private/tmp/rbx/gem, environment, gempath
    -x, /private/tmp/rbx/gem, environment, gempath

Here is the problem caused by RubyMine. It tries to run `gem` as a ruby file. Actually `gem`, `bundle` and other gems binaries in MRI are ruby scripts. But in Rubinius, as you may see, `gem` is a symlink to rbx itself.

Our solution is simple. We made ruby script which forwards all calls to normal `gem` command:

    cd /Users/Stanislav/.rbenv/versions/rbx-2.0.0-dev/
    mkdir rubymine
    cd rubymine
    ln /Users/stanislav/.rbenv/versions/rbx-2.0.0-dev/bin/rbx ruby
    touch gem
    subl gem

{% codeblock lang:ruby /Users/Stanislav/.rbenv/versions/rbx-2.0.0-dev/rubymine/gem %}
#!/Users/Stanislav/.rbenv/versions/rbx-2.0.0-dev/bin/ruby

puts `/Users/Stanislav/.rbenv/versions/rbx-2.0.0-dev/bin/gem #{ARGV*' '}`
{% endcodeblock %}

And then let RubyMine go to this `~/.rbenv/versions/rbx-2.0.0-dev/rubymine/` folder. Enjoy!:)

## Debugging

Unfortunately, RubyMine IDE debugger doesn\`t work with Rubinius 2.0 now. We hope they will fix that in the future. It would be totally perfect if this IDE debugger worked with rbx. Anyway you\`ve got all refactoring tools, code navigation and other sugar of RubyMine.

But there is a brutal way to debug Rubinius - console debugger:) Just put this code where you want to start debug session:

    Rubinius::Debugger.start

You will get used to it quickly. Here is the list of debugger\`s commands:

    debug> help
                 help: Show information about debugger commands
        b, break, brk: Set a breakpoint at a point in a method
     tb, tbreak, tbrk: Set a temporary breakpoint
            d, delete: Delete a breakpoint
              n, next: Move to the next line or conditional branch
              s, step: Step into next method call or to next line
            ni, nexti: Move to the next bytecode instruction
             f, frame: Make a specific frame in the call stack the current frame
    c, cont, continue: Continue running the target thread
        bt, backtrace: Show the current call stack
              p, eval: Run code in the current context
     dis, disassemble: Show the bytecode for the current method
              i, info: Show information about things
                  set: Set a debugger config variable
                 show: Display the value of a variable or variables

## Related links

* [Rubinius home](http://rubini.us/)
* [Steve Klabnik about Rubinius](http://blog.steveklabnik.com/posts/2011-10-04-rubinius-is-awesome)
* [My first impression of Rubinius internals](http://patshaughnessy.net/2012/1/25/my-first-impression-of-rubinius-internals)
* [Debugger](http://rubini.us/doc/en/tools/debugger/)
* [Rubinius on GitHub](https://github.com/rubinius/rubinius)

