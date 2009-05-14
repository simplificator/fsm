require File.join(File.dirname(__FILE__), 'fsm', 'errors')
require File.join(File.dirname(__FILE__), 'fsm', 'machine')
require File.join(File.dirname(__FILE__), 'fsm', 'machine_config')
require File.join(File.dirname(__FILE__), 'fsm', 'state')
require File.join(File.dirname(__FILE__), 'fsm', 'transition')
require File.join(File.dirname(__FILE__), 'fsm', 'executable')

module FSM
  module ClassMethods
    def define_fsm(&block)
      raise "FSM is already defined. Call define_fsm only once" if Machine[self]
      machine = Machine.new(self)
      Machine[self] = machine
      config = MachineConfig.new(machine)
      config.process(&block)
      machine.post_process
    end
    

  end
  
  module InstanceMethods
    #
    # Which states are reachable from the current state
    def reachable_state_names
      Machine[self.class].reachable_states.map() {|item| item.name}
    end
    
    def available_transition_names
      Machine[self.class].available_transitions.map() {|item| item.name}
    end
  end
  
  def self.included(receiver)
    receiver.class_eval do 
      extend(ClassMethods)
      include(InstanceMethods)
    end
  end  
  
end
