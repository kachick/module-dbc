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

    it 'raises a PostConditionError if the calculated value unmatched to condition' do
      expect{@foobar.func(8)}.to raise_error(Module::DbC::PostConditionError)
    end

    it 'raises an InvariantConditionError if unmatched to invariant conditions' do
      @foobar.func(9)
      expect{@foobar.func(9)}.to raise_error(Module::DbC::InvariantConditionError)
    end
    
    it 'prepends specific named module' do
      expect(Module::DbC::SpecHelpers::FooBar.ancestors.first.name).to \
        eq('Module::DbC::SpecHelpers::FooBar::DbC_func')
      expect{Module::DbC::SpecHelpers::FooBar::DbC_func}.to raise_error(NameError)
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
        end
        
        @instance = cls.new      
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
