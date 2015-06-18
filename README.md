module-dbc
===========

[![Build Status](https://secure.travis-ci.org/kachick/module-dbc.png)](http://travis-ci.org/kachick/module-dbc)
[![Gem Version](https://badge.fury.io/rb/module-dbc.png)](http://badge.fury.io/rb/module-dbc)
[![Dependency Status](https://gemnasium.com/kachick/module-dbc.svg)](https://gemnasium.com/kachick/module-dbc)

Description
-----------

An imitation of DbC in Ruby.

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
  dbc :counter, return: Integer #=> :return is an alias of :post

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

* Ruby - [2.1 or later](http://travis-ci.org/#!/kachick/module-dbc)

Install
-------

```bash
gem install module-dbc
```

Link
----

* [Home](http://kachick.github.com/module-dbc/)
* [code](https://github.com/kachick/module-dbc)
* [API](http://www.rubydoc.info/github/kachick/module-dbc)
* [issues](https://github.com/kachick/module-dbc/issues)
* [CI](http://travis-ci.org/#!/kachick/module-dbc)
* [gem](https://rubygems.org/gems/module-dbc)

License
--------

The MIT X11 License  
Copyright (c) 2013 Kenichi Kamiya  
See MIT-LICENSE for further details.
