# coding: us-ascii
# Copyright (c) 2013 Kenichi Kamiya

require 'optionalargument'

class Module

  module DbC

    class Error < StandardError; end
    class PreConditionError < Error; end
    class PostConditionError < Error; end
    class InvariantConditionError < Error; end
    class PreInvariantConditionError < InvariantConditionError; end
    class PostInvariantConditionError < InvariantConditionError; end

    # @return [Class]
    DbCOptArg = OptionalArgument.define {
      opt :precondition,
          condition: CAN(:call),
          aliases: [:pre]

      opt :postcondition,
          condition: AND(CAN(:call), ->v{v.arity == 1}),
          aliases: [:post]

      opt :invariant,
          condition: Proc
    }

    private

    # @param [Symbol, String, #to_sym] origin
    # @param [Hash] options
    # @option options [#call] :pre
    # @option options [#call] :post
    # @option options [#call] :invariant
    # @return [self]
    def dbc(origin, options={})
      origin = origin.to_sym
      opts = DbCOptArg.parse options

      prepend(prependable = Module.new do
        define_method origin do |*args, &block|
          if opts.pre?
            unless instance_exec(*args, &opts.pre)
              raise PreConditionError, "pre-conditon is invalid: (args: #{args.join ','})"
            end
          end

          if opts.invariant?
            unless instance_exec(&opts.invariant)
              raise PreInvariantConditionError, "invariant-conditon is invalid"
            end
          end

          ret = super(*args, &block)

          if opts.invariant?
            unless instance_exec(&opts.invariant)
              raise PostInvariantConditionError, "invariant-conditon is invalid"
            end
          end

          if opts.post?
            unless instance_exec(ret, &opts.post)
              raise PostConditionError, "post-conditon is invalid: (ret: #{ret})"
            end
          end

          ret
        end
      end)

      # For readability on ancestors
      const_set :"DbC_#{origin}", prependable
      private_constant :"DbC_#{origin}"

      self
    end

  end

end
