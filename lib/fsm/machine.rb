module FSM
  class Machine
    attr_accessor(:initial_state_name, :current_state_attribute_name, :states)
    
    def initialize(target_class)
      @target_class = target_class
      self.states = {}
      self.current_state_attribute_name = :state
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
      self.initial_state_name=(name) unless self.initial_state_name
    end
    
    def initial_state_name=(value)
      raise UnknownState.new("Unknown state '#{value}'. Define states first with state(name)") unless self.states[value]
      @initial_state_name = value
    end
    
    def transition(name, from_name, to_name, options = {})
      raise ArgumentError.new("name, from_name and to_name are required") if name.nil? || from_name.nil? || to_name.nil?
      raise UnknownState.new("Unknown source state '#{from}'") unless self.states[from_name]
      raise UnknownState.new("Unknown target state '#{to}'") unless self.states[to_name]
      
      from_state = self.states[from_name]
      to_state = self.states[to_name]
      
      transition = Transition.new(name, from_state, to_state, options)
      from_state.add_transition(transition)
      
      define_transition_method(name)
      
    end
    
    def self.get_current_state_name(target)
      value = target.send(Machine[target.class].current_state_attribute_name)
      (value && value.is_a?(String)) ? value.intern : value
    end
    
    def self.set_current_state_name(target, value)
      target.send("#{Machine[target.class].current_state_attribute_name}=", value)
    end

    
    def reachable_states(target)
      reachables = []
      current_state_name = Machine.get_current_state_name(target)
      self.states.map do |name, state|
        reachables += state.to_states if state.name == current_state_name
      end
      reachables
    end
    
    def available_transitions(target)
      self.states[Machine.get_current_state_name(target)].transitions.values
    end
    
    private
    
    def define_transition_method(name)
      @target_class.instance_eval do
        define_method(name) do |*args|
          machine = Machine[self.class]
          from_name = Machine.get_current_state_name(self)
          from_state = machine.states[from_name]
          
          entry = from_state.transitions.detect() {|to_name, tr| tr.name == name}
          transition = entry.last if entry
          raise InvalidStateTransition.new("No transition with name '#{name}' defined from '#{from_name}'") unless transition
          to_state = transition.to
          
          from_state.exit(self)
          transition.fire_event(self, args)
          to_state.enter(self)
          Machine.set_current_state_name(self, to_state.name)
          true
          
          
          
          #to_state = machine.states[to_name]
          #transition = from_state.transitions[to_name]
          #raise InvalidStateTransition.new("No transition defined from #{from_name} -> #{to_name}") unless transition
          
          #from_state.exit(self)
          #transition.fire_event(self, args)
          #to_state.enter(self)
          #Machine.set_current_state_name(self, to_name)
          #true # at the moment always return true ... as soon as we have guards or thelike this could be false as well 
        end
      end
    end


  end
end