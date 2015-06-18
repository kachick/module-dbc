# coding: us-ascii

require_relative 'helper'

describe Module::DbC do
  context '.dbc' do
    before(:each) do
      @foobar = Module::DbC::SpecHelpers::FooBar.new
    end

    it 'returns origin value when passed all conditions' do
      expect(@foobar.func(9)).to eq(10)
    end

    it 'raises a PreConditionError if the argument block unmatched to condition' do
      expect{@foobar.func(0)}.to raise_error(Module::DbC::PreConditionError)
    end
    
    context 'when the postconditon is a Proc' do
      it 'raises a PostConditionError if the calculated value unmatched to condition' do
        expect{@foobar.func(8)}.to raise_error(Module::DbC::PostConditionError)
      end
    end

    context 'when the postconditon is not a Proc' do
      it 'raises an InvariantConditionError if unmatched to invariant conditions' do
        obj = Object.new
        class << obj
          extend Module::DbC
          dbc def func(arg)
            arg + 1
          end, return: Fixnum
        end

        expect{obj.func(1.0)}.to raise_error(Module::DbC::PostConditionError)
        expect(obj.func(1)).to eq(2)
      end
    end

    it 'raises an InvariantConditionError if unmatched to invariant conditions' do
      @foobar.func(9)
      expect{@foobar.func(9)}.to raise_error(Module::DbC::InvariantConditionError)
    end

    it 'prepends specific named module' do
      expect(Module::DbC::SpecHelpers::FooBar.ancestors.first.name).to \
        eq('Module::DbC::SpecHelpers::FooBar::DbCPrpendable')
      expect{Module::DbC::SpecHelpers::FooBar::DbCPrpendable}.to raise_error(NameError)
    end
    
    it 'overrides on the single prepended module when called twice' do
      cls = Class.new do
        extend Module::DbC
        dbc def foo
          :foo
        end, return: Symbol

        dbc def bar
          :bar
        end, return: String
      end

      expect(cls.ancestors[1]).to equal(cls)
      expect(cls.new.foo).to eq(:foo)
      expect{cls.new.bar}.to raise_error(Module::DbC::PostConditionError)
    end
  
    context 'variety of arguments' do
      before :each do
        cls = Class.new do
          extend Module::DbC
          
          def self.val
            :class_val
          end
          
          def val
            :intance_val
          end
          
          dbc def pre_checker
            :ret
          end, pre: -> { val == :intance_val }
          
          dbc def post_checker
            :ret
          end, post: -> ret{ val == :intance_val }
          
          dbc def multiple_arguments(must, df=:def, *rest, kmust:, kdf: :kdf, **krests)
            :ret
          end, pre: -> must, df, *rest, kmust:, kdf: :kdf, **krests{ kmust == :km }
        end
        
        @instance = cls.new
      end
      
      it 'sends arguments from any way' do
        expect(@instance.multiple_arguments :must, :def2, kmust: :km).to eq(:ret)
      end

      context 'preconditions' do
        it 'evaluates conditions under instance scope' do
          expect(@instance.pre_checker).to eq(:ret)
        end
      end
      
      context 'postconditions' do
        it 'evaluates conditions under instance scope' do
          expect(@instance.post_checker).to eq(:ret)
        end
      end
    end
  end
end
