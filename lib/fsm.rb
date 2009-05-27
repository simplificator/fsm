%w[options errors machine state transition executable builder state_attribute_interceptor].each do |item|
  require File.join(File.dirname(__FILE__), 'fsm', item)
end

module FSM
  module ClassMethods
    def define_fsm(&block)
      raise 'FSM is already defined. Call define_fsm only once' if Machine[self]
      builder = Builder.new(self)
      Machine[self] = builder.process(&block)
      
      # TODO: check if all states are reachable
      # TODO: other checks? islands?
      
      # create alias for state attribute method to intercept it 
      # intercept
      FSM::StateAttributeInterceptor.add_interceptor(self)
      
      
    end
    
    def draw_graph(options = {})
      machine = Machine[self]
      raise 'No FSM defined. Call define_fsm first' unless machine
      machine.draw_graph(options)
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
