require 'test_helper'

class Water
  attr_accessor(:state_of_material)
  attr_accessor(:temperature)
  include FSM
  define_fsm do
    # now define all the states
    # you can add :enter / :exit callbacks (callback can be a String, Symbol or Proc)
    # these callbacks are triggered on any transition from/to this state and do not receive any arguments
    states(:gas, :liquid)
    state(:solid, :enter => :on_enter_solid, :exit => :on_exit_solid)
    
    # define all valid transitions (name, from, to). This will define a method with the given name.
    # you can define :event callback which is called only on this transition and receives the arguments passed to the
    # transition method
    transition(:heat_up, :solid, :liquid, :event => :on_heat_up, :guard => :guard_solid_to_liquid)
    transition(:heat_up, :liquid, :gas, :event => :on_heat_up, :guard => :guard_liquid_to_gas)
    transition(:cool_down, :gas, :liquid, :event => :on_cool_down, :guard => :guard_gas_to_liquid)
    transition(:cool_down, :liquid, :solid, :event => :on_cool_down, :guard => :guard_liquid_to_solid)
    
    # define the attribute which is used to store the state (defaults to :state)
    state_attribute(:state_of_material)
    
    # define the initial state (defaults to the first state defined - :gas in this sample)
    initial(:solid)
  end
  
  def initialize(temperature = -20)
    self.temperature = temperature
  end
  
  private
  def on_enter_solid()
  end
  def on_exit_solid()
  end
  
  def guard_solid_to_liquid(delta)
    self.temperature + delta >= 0
  end
  def guard_liquid_to_gas(delta)
    self.temperature + delta >= 100
  end
  
  def guard_gas_to_liquid(delta)
    self.temperature - delta < 100
  end
  
  def guard_liquid_to_solid(delta)
    self.temperature - delta < 0
  end
  
  def on_heat_up(delta)
    self.temperature += delta
  end
  
  def on_cool_down(delta)
    self.temperature -= delta
  end
end

class WaterSampleTest < Test::Unit::TestCase
  context 'Water' do
    
    should 'cycle through material states' do
      w = Water.new
      assert_equal(:solid, w.state_of_material)
      assert w.heat_up(30)
      assert_equal(:liquid, w.state_of_material)
      assert !w.heat_up(10)
      assert w.heat_up(90)
      assert_equal(:gas, w.state_of_material)
      assert w.cool_down(50)
      assert_equal(:liquid, w.state_of_material)
      assert w.cool_down(70)
      assert_equal(:solid, w.state_of_material)
      
      assert_raise(FSM::InvalidStateTransition) do
        w.cool_down
      end
    end
  
  end
end
