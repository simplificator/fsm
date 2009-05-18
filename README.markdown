# fsm

FSM is a simple finite state machine

## Usage
    class Water
      include FSM
      define_fsm do
        # now define all the states
        # you can add :enter / :exit callbacks (callback can be a String, Symbol or Proc)
        # these callbacks are triggered on any transition from/to this state
        
        state(:gas)
        state(:liquid)
        state(:solid, :enter => :on_enter_solid, :exit => :on_exit_solid)
        
        # define all valid transitions (name, from, to)
        # you can define callbacks which are called only on this transition
        transition(:heat, :solid, :liquid, :event => :liquified)
        transition(:heat, :liquid, :gas)     # look mam.... two transitions with same name
        transition(:cooldown, :gas, :liquid)
        transition(:cooldown, :liquid, :solid)
        
        # define the attribute which is used to store the state (defaults to :state)
        state(:state_of_material)
        
        # define the initial state (defaults to the first state defined - :gas in this sample)
        initial(:liquid)
      end
    end
## Copyright
Copyright (c) 2009 simplificator GmbH. See LICENSE for details.
