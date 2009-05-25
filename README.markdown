# fsm

FSM is a simple finite state machine

## Usage
    class Water
      include FSM
      # The state machine is specified as a block in define_fsm.
      define_fsm do
        # now define all the states
        # you can add :enter / :exit callbacks (callback can be a String, Symbol or Proc)
        # these callbacks are triggered on any transition from/to this state
        
        state(:gas)
        state(:liquid)
        state(:solid, :enter => :on_enter_solid, :exit => :on_exit_solid)
        
        # define all valid transitions (arguments are name of transition, from state name, to state name)
        # you can define callbacks which are called only on this transition
        transition(:heat_up, :solid, :liquid, :event => :liquified)
        transition(:heat_up, :liquid, :gas)     # look mam.... two transitions with same name
        transition(:cool_down, :gas, :liquid)
        transition(:cool_down, :liquid, :solid)
        
        # define the attribute which is used to store the state (defaults to :state)
        state(:state_of_material)
        
        # define the initial state (defaults to the first state defined - :gas in this sample)
        initial(:liquid)
      end
      
      private
      # callbacks here...
      def ...
    end
    
    # then you can call these methods
    w = Water.new
    w.heat  # the name of the transition is the name of the method
    w.reachable_state_names
    w.available_transition_names
    w.cool_down # again... it's the name of the transition
    w.state_of_material
    
## Graphviz / Dot format
FSM supports the dot format of graphviz (http://www.graphviz.org/).
If you have the graphviz tools installed (the dot executable must be on the path) then
you can export a graph to png like this
    # Export to water.png in the current dir
    Water.dot    
    # Export in another format. (see graphviz documentation for supported file formats)
    Water.dot(:format => :foo)
    # Change the extension (defaults to the format)
    Water.dot(:format => :jpg, :extension => :jpeg)
    # Specify a custom file
    Water.dot(:outfile => '/afile.png')
  
    
## Copyright
Copyright (c) 2009 simplificator GmbH. See LICENSE for details.
