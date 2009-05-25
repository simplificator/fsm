module FSM
  #
  # A State has a name and a list of outgoing transitions.
  # 
  class State
    include FSM::Options::InstanceMethods
    attr_reader(:name, :transitions)
    
    # name: a symbol which identifies this state
    # options
    #  * :enter : a symbol or string or Proc
    #  * :exit : a symbol or string or Proc
    def initialize(name, target_class, options = {})
      raise ArgumentError.new('name and target_class is required') unless name && target_class
      assert_options(options, [:enter, :exit])
      @name = name
      @target_class = target_class
      @enter = Executable.new options[:enter] if options.has_key?(:enter)
      @exit = Executable.new options[:exit] if options.has_key?(:exit)
      @transitions = {}
    end
    
    # Called when this state is entered
    def enter(target)
      @enter.execute(target) if @enter
      nil
    end
    # Called when this state is exited
    def exit(target)
      @exit.execute(target) if @exit
      nil
    end    
    
    def add_transition(transition)
      raise ArgumentError.new("#{self} already has a transition to '#{transition.name}'") if @transitions.has_key?(transition.name)
      raise ArgumentError.new("the transition '#{transition.name}' is already defined") if @transitions.detect() {|to_name, tr| transition.name == tr.name}
      @transitions[transition.to.name] = transition
    end
    
    # All states that are reachable form this state by one hop
    def to_states
      @transitions.map { |to_name, transition| transition.to}
    end
    def final?
      @transitions.empty?
    end
    
    def initial?
      Machine[@target_class].initial_state_name == self.name
    end
    
    def to_s
      "State '#{self.name}' is "
    end
    
    def to_dot(options = {})
      
      if final?
        attrs = "style=bold"
      elsif initial?
        attrs = "style=bold, label=\"#{self.name}\\n(initial)\""
      else
        attrs = ""
      end
      "#{self.name}[#{attrs}]"
    end
  end
end