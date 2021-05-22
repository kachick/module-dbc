module-dbc
===========

* ***This repository is archived***
* ***No longer maintained***
* ***All versions have been yanked from https://rubygems.org for releasing valuable namespace for others***

Description
-----------

An imitation of DbC(Design By Contract) in Ruby.

Features
--------

* Pure Ruby :)

Usage
-----

```ruby
require 'module/dbc'

class FooBar
  extend Module::DbC

  def initialize
    @counter = 1
  end

  attr_reader :counter
  dbc :counter, return: Integer # :return is an alias of :post

  dbc def func(arg)
    @counter += 1
    arg + 1
  end, pre: ->arg{ arg > 1 },
       post: ->ret{ ret >= 10 },
       invariant: ->{ @counter < 3 }
end

FooBar.new.func 0 #=> fail pre-conditon is invalid: (args: 0) (Module::DbC::PreConditionError)
FooBar.new.func 8 #=> fail post-conditon is invalid: (ret: 9) (Module::DbC::PostConditionError)
FooBar.new.func 9 #=> pass

foo = FooBar.new
foo.counter       #=> 1
foo.func 11       #=> pass
foo.func 11       #=> fail invariant-conditon is invalid (Module::DbC::PostInvariantConditionError)
```

Requirements
-------------

* Ruby - [2.2 or later](http://travis-ci.org/#!/kachick/module-dbc)

License
--------

The MIT X11 License  
Copyright (c) 2013 Kenichi Kamiya  
See MIT-LICENSE for further details.
