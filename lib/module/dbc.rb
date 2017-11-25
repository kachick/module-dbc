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
          condition: Proc,
          aliases: [:pre]

      opt :postcondition,
          condition: OR(AND(Proc, ->v{v.arity == 1}), CAN(:===)),
          aliases: [:post, :return]

      opt :invariant,
          condition: Proc
    }

    private

    # @param [Symbol, String, #to_sym] origin
    # @param [Hash] options
    # @option options [Proc] :precondition
    # @option options [Proc] :pre same as :precondition
    # @option options [Proc, #===] :postcondition
    # @option options [Proc, #===] :post same as :postcondition
    # @option options [Proc, #===] :return same as :postcondition
    # @option options [Proc] :invariant
    # @return [self]
    def dbc(origin, options={})
      origin = origin.to_sym
      opts = DbCOptArg.parse options

      @_dbc_prependable ||= ( prepend(prependable = Module.new); prependable )

      @_dbc_prependable.module_exec do
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
            if opts.post.kind_of?(Proc)
              unless instance_exec(ret, &opts.post)
                raise PostConditionError, "post-conditon is invalid: (return: #{ret})"
              end
            else
              unless opts.post === ret
                raise PostConditionError, "invalid return value: (return: #{ret}, expected: #{opts.post})"
              end
            end
          end

          ret
        end
      end

      # For readability on ancestors
      unless const_defined? :DbCPrpendable
        const_set :DbCPrpendable, @_dbc_prependable
        private_constant :DbCPrpendable
      end

      self
    end
  end
end
