require 'test_helper'

class TransitionTest < Test::Unit::TestCase
  context 'Initializer' do
    
    
    should 'require name, from and to' do
      bli_state = FSM::State.new('bli', self)
      blo_state = FSM::State.new('blo', self)
      assert_raise(ArgumentError) do
        FSM::Transition.new(nil, nil, nil)
      end
      assert_raise(ArgumentError) do
        FSM::Transition.new(:name, nil, nil)
      end
      assert_raise(ArgumentError) do
        FSM::Transition.new(nil, bli_state, nil)
      end
      assert_raise(ArgumentError) do
        FSM::Transition.new(nil, nil, blo_state)
      end
      assert_raise(ArgumentError) do
        FSM::Transition.new(:name, bli_state, nil)
      end
      assert_raise(ArgumentError) do
        FSM::Transition.new(nil, blo_state, blo_state)
      end
      assert_raise(ArgumentError) do
        FSM::Transition.new(:name, nil, bli_state)
      end
      
      FSM::Transition.new(:name, bli_state, blo_state)
    end
    
    should 'allow only valid options' do
      bli_state = FSM::State.new('bli', self)
      blo_state = FSM::State.new('blo', self)
      assert_raise(ArgumentError) do
        FSM::Transition.new(:name, bli_state, blo_state, :foo => 12)
      end
      FSM::Transition.new(:name, bli_state, blo_state, :event => :some)
      FSM::Transition.new(:name, bli_state, blo_state, :guard => :some)
    end
  end
end
