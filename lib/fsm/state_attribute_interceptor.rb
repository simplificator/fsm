module FSM
  class StateAttributeInterceptor
    def self.add_interceptor(klass)
      state_attribute_name = Machine[klass].current_state_attribute_name
      hierarchy = klass.ancestors.map {|ancestor| ancestor.to_s}
      
      if hierarchy.include?("ActiveRecord::Base")
        bar(klass)
      else 
        foo(klass)
      end
     
    end
    
    private
    def self.bar(klass)
      klass.instance_eval() do
        define_method(Machine[klass].current_state_attribute_name) do
          value = read_attribute(Machine[self.class].current_state_attribute_name) || Machine[self.class].initial_state_name
          value.is_a?(String) ? value.intern : value
        end
      end
    end
    
    def self.foo(klass)
      klass.instance_eval() do 
        alias_method "fsm_state_attribute", Machine[klass].current_state_attribute_name
        define_method(Machine[klass].current_state_attribute_name) do
          value = fsm_state_attribute || Machine[self.class].initial_state_name
          value.is_a?(String) ? value.intern : value
        end
      end
    end
  end
end