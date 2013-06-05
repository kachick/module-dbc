$VERBOSE = true

require_relative '../lib/module/dbc'

class FooBar
  extend Module::DbC

  def initialize
    @counter = 1
  end

  def func(arg)
    @counter += 1
    arg + 1
  end

  dbc :func,
       pre: ->arg{arg > 1},
       post: ->ret{ret >= 10},
       invariant: ->{@counter < 3}
end

#FooBar.new.func 0 #=> fail pre-conditon is invalid: (args: 0) (Module::DbC::PreConditionError)
#FooBar.new.func 8 #=> fail post-conditon is invalid: (ret: 9) (Module::DbC::PostConditionError)
FooBar.new.func 9 #=> pass

foo = FooBar.new
foo.func 11       #=> pass
foo.func 11       #=> fail invariant-conditon is invalid (Module::DbC::PostInvariantConditionError)