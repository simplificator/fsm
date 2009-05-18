require 'test_helper'

class Water
  attr_accessor(:state_of_material)
  include FSM
  define_fsm do
    # now define all the states
    # you can add :enter / :exit callbacks (callback can be a String, Symbol or Proc)
    # these callbacks are triggered on any transition from/to this state and do not receive any arguments
    state(:gas)
    state(:liquid)
    state(:solid, :enter => :on_enter_solid, :exit => :on_exit_solid)
    
    # define all valid transitions (name, from, to). This will define a method with the given name.
    # you can define :event callback which is called only on this transition and receives the arguments passed to the
    # transition method
    transition(:heat_up, :solid, :liquid)
    transition(:heat_up, :liquid, :gas)
    transition(:cool_down, :gas, :liquid)
    transition(:cool_down, :liquid, :solid)
    
    # define the attribute which is used to store the state (defaults to :state)
    state_attribute(:state_of_material)
    
    # define the initial state (defaults to the first state defined - :gas in this sample)
    initial(:solid)
  end
  private
  def on_enter_solid()
  end
  def on_exit_solid()
  end
  
end

class WaterSampleTest < Test::Unit::TestCase
  context 'Water' do
    
    should 'cycle through material states' do
      w = Water.new
      assert_equal(:solid, w.state_of_material)
      w.heat_up
      assert_equal(:liquid, w.state_of_material)
      w.heat_up
      assert_equal(:gas, w.state_of_material)
      w.cool_down
      assert_equal(:liquid, w.state_of_material)
      w.cool_down
      assert_equal(:solid, w.state_of_material)
      
      assert_raise(FSM::InvalidStateTransition) do
        w.cool_down
      end
    end
  
  end
end
