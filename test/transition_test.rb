require 'test_helper'

class TransitionTest < Test::Unit::TestCase
  context 'Initializer' do
    should 'require name, from and to' do
      assert_raise(ArgumentError) do
        FSM::Transition.new(nil, nil, nil)
      end
      assert_raise(ArgumentError) do
        FSM::Transition.new('bla', nil, nil)
      end
      assert_raise(ArgumentError) do
        FSM::Transition.new(nil, 'bli', nil)
      end
      assert_raise(ArgumentError) do
        FSM::Transition.new(nil, nil, 'blo')
      end
      assert_raise(ArgumentError) do
        FSM::Transition.new('bli', 'bli', nil)
      end
      assert_raise(ArgumentError) do
        FSM::Transition.new(nil, 'blo', 'blo')
      end
      assert_raise(ArgumentError) do
        FSM::Transition.new('blo', nil, 'bli')
      end
      
      FSM::Transition.new('bla', 'bli', 'blo')
    end
    
    should 'allow only valid options' do
      assert_raise(ArgumentError) do
        FSM::Transition.new('bla', 'bli', 'blo', :foo => 12)
      end
      FSM::Transition.new('bla', 'bli', 'blo', :event => :some)
    end
  end
end
