require File.join(File.dirname(__FILE__), 'fsm', 'errors')
require File.join(File.dirname(__FILE__), 'fsm', 'machine')
require File.join(File.dirname(__FILE__), 'fsm', 'state')
require File.join(File.dirname(__FILE__), 'fsm', 'transition')
require File.join(File.dirname(__FILE__), 'fsm', 'executable')
require File.join(File.dirname(__FILE__), 'fsm', 'builder')

module FSM
  module ClassMethods
    def define_fsm(&block)
      raise 'FSM is already defined. Call define_fsm only once' if Machine[self]
      builder = Builder.new(self)
      Machine[self] = builder.process(&block)
    end
  end
  
  module InstanceMethods
    #
    # Which states are reachable from the current state
    def reachable_state_names
      Machine[self.class].reachable_states(self).map() {|item| item.name}
    end
    
    def available_transition_names
      Machine[self.class].available_transitions(self).map() {|item| item.name}
    end
  end
  
  def self.included(receiver)
    receiver.class_eval do 
      extend(ClassMethods)
      include(InstanceMethods)
    end
  end  
  
end
