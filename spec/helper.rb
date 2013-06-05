require 'rspec'

require_relative '../lib/module/dbc'

module Module::DbC::SpecHelpers
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
end