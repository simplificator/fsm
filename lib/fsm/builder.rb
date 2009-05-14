module FSM
  # Builder exposees 'only' (well there are some other methods exposed) the methods that are required to build the configuration
  class Builder
    # Blank Slate
    instance_methods.each do |m| 
      undef_method m unless  m == '__send__' || m == '__id__' || m == 'instance_eval'
    end
    
    def initialize(target_class)
      @target_class = target_class
      @machine = Machine.new(target_class)
    end
    
    def process(&block)
      raise ArgumentError.new('Block expected') unless block_given?
      self.instance_eval(&block)
      @machine
    end
    
    private
    def transition(name, from_name, to_name, options = {})
      @machine.transition(name, from_name, to_name, options = {})
      nil
    end
    
    def state_attribute(name)
      raise ArgumentError.new('Invalid attribute name') if name == nil
      @machine.current_state_attribute_name = name
      nil
    end
    
    def initial(name)
      @machine.initial_state_name = name
      nil
    end
    
    def state(name, options = {})
      @machine.state(name, options)
      nil
    end
    
    
  end
end