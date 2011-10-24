module FSM
  # Builder exposes 'only' (well there are some other methods exposed) the methods that are required to build the configuration
  class Builder

    # Blank Slate
    if RUBY_VERSION < "1.9"
      instance_methods.each do |m|
          undef_method m unless  m == "object_id" || m == "__send__" || m == "__id__" || m == "instance_eval"
      end
    else
      instance_methods.each do |m|
          undef_method m unless  m == :object_id || m == :__send__ || m == :__id__ || m == :instance_eval
      end
    end

    # Create a new Builder which creates a Machine for the target_class
    def initialize(target_class)
      @target_class = target_class
      @machine = Machine.new(target_class)
    end

    def process(&block)
      raise ArgumentError.new('Block expected') unless block_given?
      self.instance_eval(&block)
      @machine.build_transition_methods
      @machine.build_state_check_methods
      @machine
    end

    private
    # Add a transition
    #  * name of the transition
    #  * from_name: name of the source state (symbol)
    #  * to_name: name of the target state (symbol)
    #  * options
    #
    def transition(name, from_names, to_name, options = {})
      Array(from_names).each do |from_name|
        @machine.transition(name, from_name, to_name, options)
      end
      nil # do not expose FSM details
    end

    def state_attribute(name)
      raise ArgumentError.new('Invalid attribute name') if name == nil
      @machine.current_state_attribute_name = name
      nil # do not expose FSM details
    end

    def initial(name)
      @machine.initial_state_name = name
      nil # do not expose FSM details
    end

    def state(name, options = {})
      @machine.state(name, options)
      nil # do not expose FSM details
    end

    def states(*names)
      names.each do |name|
        state(name)
      end
    end
  end
end