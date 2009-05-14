module FSM
  #
  # A State has a name and a list of outgoing transitions.
  # 
  class State
    attr_reader(:name, :transitions)
    
    # name: a symbol which identifies this state
    # options
    #  * :enter : a symbol or string or Proc
    #  * :exit : a symbol or string or Proc
    def initialize(name, options = {})
      @name = name
      @enter = Executable.new options[:enter]
      @exit = Executable.new options[:exit]
      @transitions = {}
    end
    
    # Called when this state is entered
    def enter(target)
      @enter.execute(target, nil)
    end
    # Called when this state is exited
    def exit(target)
      @exit.execute(target, nil)
    end    
    
    def add_transition(transition)
      raise ArgumentError.new("#{self} already has an transition '#{transition.name}'") if @transitions.has_key?(transition.name)
      @transitions[transition.to.name] = transition
    end
    
    # All states that are reachable form this state by one hop
    def to_states
      @transitions.map { |to_name, transition| transition.to}
    end
    
    def to_s
      "State '#{self.name}'"
    end

  end
end