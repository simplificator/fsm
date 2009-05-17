require 'test_helper'

class StateTest < Test::Unit::TestCase
  context 'Initializer' do
    should 'require name' do
      assert_raise(ArgumentError) do
        FSM::State.new(nil, nil, nil)
      end
     
      FSM::State.new('bla')
    end
    
    should 'allow only valid options' do
      assert_raise(ArgumentError) do
        FSM::State.new('bla', :foo => 12)
      end
      FSM::State.new('bla', :enter => :some)
      FSM::State.new('bla', :exit => :some)
    end
  end
end
