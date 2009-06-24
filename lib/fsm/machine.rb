module FSM
  class Machine
    attr_accessor(:initial_state_name, :current_state_attribute_name, :states, :transitions)
    
    def initialize(target_class)
      @target_class = target_class
      self.states = []
      self.transitions = []
      self.current_state_attribute_name = :state
    end
    
    def self.[](includer)
      (@machines ||= {})[includer]
    end

    def self.[]=(*args)
      (@machines ||= {})[args.first] = args.last
    end
    
    def state(name, options = {})
      raise "State is already defined: '#{name}'" if self.state_for_name(name, true)
      self.states << State.new(name, @target_class, options)
      self.initial_state_name=(name) unless self.initial_state_name
    end
    
    def initial_state_name=(value)
      raise UnknownState.new("Unknown state '#{value}'. Define states first with state(name)") unless self.state_for_name(value, true)
      @initial_state_name = value
    end
    
    def transition(name, from_name, to_name, options = {})
      raise ArgumentError.new("name, from_name and to_name are required") if name.nil? || from_name.nil? || to_name.nil?
      
      from_state = self.state_for_name(from_name)
      to_state = self.state_for_name(to_name)
      transition = Transition.new(name, from_state, to_state, options)
      from_state.add_transition(transition)
      self.transitions << transition
    end
    
    def self.get_current_state_name(target)
      target.send(Machine[target.class].current_state_attribute_name) || self.initial_state_name
    end
    
    def self.set_current_state_name(target, value)
      value = value && value.is_a?(Symbol) ? value.to_s : value
      target.send("#{Machine[target.class].current_state_attribute_name}=", value)
    end

    
    def reachable_states(target)
      reachables = []
      current_state_name = Machine.get_current_state_name(target)
      self.states.map do |state|
        reachables += state.to_states if state.name == current_state_name
      end
      reachables
    end
    
    def available_transitions(target)
      current_state_name = Machine.get_current_state_name(target)
      state = state_for_name(current_state_name)
      state.transitions.values
    end
    
    
    def build_transition_methods
      names = self.transitions.map() {|transition| transition.name}.uniq
      names.each do |name|
        define_transition_method(name)
      end
    end
    
    # Lookup a State by it's name
    # raises ArgumentError if state can not be found unless quiet is set to true
    def state_for_name(name, quiet = false)
      state = self.states.detect() {|state| state.name == name}
      raise ArgumentError.new("Unknonw state '#{name}'") unless quiet || state
      state
    end
    
    # Convert this state machine to the dot format of graphviz
    def to_dot(options = {})
      s = self.states.map do |state|
        "  #{state.to_dot(options)};"
      end
      t = self.transitions.map do |transition|
        "  #{transition.to_dot(options)};"
      end
      "digraph FSM_#{@target_class.name} {\n#{s.join("\n")}\n\n#{t.join("\n")}\n}"
    end
    
    # 
    def draw_graph(options = {})
      format = options[:format] || :png
      extension = options[:extension] || format
      file_name = options[:outfile] || "#{@target_class.name.downcase}.#{extension}" 
      cmd = "dot -T#{format} -o#{file_name}"
      IO.popen cmd, 'w' do |io| 
        io.write to_dot
      end 
      raise 'dot failed' unless $?.success? 
    end
    
    private
    
    # defines a transition method on the target class.
    # this is the method triggering the state change.
    #
    def define_transition_method(name)
      @target_class.instance_eval do
        define_method(name) do |*args|
          machine = Machine[self.class]
          from_name = Machine.get_current_state_name(self)
          from_state = machine.state_for_name(from_name)
          
          entry = from_state.transitions.detect() {|to_name, tr| tr.name == name}
          transition = entry.last if entry
          raise InvalidStateTransition.new("No transition with name '#{name}' defined from '#{from_name}'") unless transition
          to_state = transition.to
          
          from_state.exit(self)
          if transition.fire?(self, args)
            transition.fire_event(self, args)
            to_state.enter(self)
            Machine.set_current_state_name(self, to_state.name)
            true
          else
            false
          end
        end
      end
    end


  end
end