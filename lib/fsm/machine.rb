module FSM
  class Machine
    attr_accessor(:current_state, :states, :state_attribute)
    
    def initialize(klass)
      @klass = klass
      self.states = {}
      self.state_attribute = :state
    end
    
    def self.[](includer)
      (@machines ||= {})[includer]
    end

    def self.[]=(*args)
      (@machines ||= {})[args.first] = args.last
    end
    
    def state(name, options = {})
      raise "State is already defined: '#{name}'" if self.states[name]
      self.states[name] = State.new(name, options)
      initial(name) unless self.current_state
      nil
    end
    
    def initial(name)
      self.current_state = self.states[name]
      raise UnknownState.new("Unknown state '#{name}'. Define states first with state(name)") unless self.current_state
      nil
    end
    
    def transition(name, from_name, to_name, options = {})
      raise ArgumentError.new("name, from_name and to_name are required") if name.nil? || from_name.nil? || to_name.nil?
      raise UnknownState.new("Unknown source state '#{from}'") unless self.states[from_name]
      raise UnknownState.new("Unknown target state '#{to}'") unless self.states[to_name]
      define_transition_method(name, to_name)
      from_state = self.states[from_name]
      to_state = self.states[to_name]
      transition = Transition.new(name, from_state, to_state, options)
      from_state.transitions[to_state.name] = transition
      nil
    end
    
    def attribute(name)
      self.state_attribute = name
    end
    
    def reachable_states()
      self.states.map do |name, state|
        state.to_states if state == current_state
      end.flatten.compact
    end
    
    def available_transitions()
      current_state.transitions.values  
    end
    
    
    def post_process
      define_state_attribute_methods(self.state_attribute)
    end
    
    
    
    private
    
    def define_state_attribute_methods(name)
      @klass.instance_eval do
        define_method("#{name}") do 
          Machine[self.class].current_state.name
        end
        
        define_method("#{name}=") do |value|
          Machine[self.class].current_state = Machine[self.class].states[value]
          raise("Unknown State #{value}") unless Machine[self.class].current_state
        end
      end
    end
    
    def define_transition_method(name, to_name)
      @klass.instance_eval do
        define_method(name) do |*args|
          from_state = Machine[self.class].current_state
          to_state = Machine[self.class].states[to_name]
          transition = from_state.transitions[to_name]
          raise InvalidStateTransition.new("No transition defined from #{from_state.name} -> #{to_state.name}") unless transition
          
          from_state.exit(self)
          transition.fire_event(self, args)
          to_state.enter(self)
          Machine[self.class].current_state = to_state
        end
      end
    end


  end
end