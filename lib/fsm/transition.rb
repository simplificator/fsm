module FSM
  class Transition
    include FSM::Options::InstanceMethods
    attr_accessor(:name, :from, :to, :event, :guard)
    def initialize(name, from, to, options = {})
      raise ArgumentError.new("name, from and to are required but were '#{name}', '#{from}' and '#{to}'") unless name && from && to
      assert_options(options, [:event, :guard])
      self.name = name
      self.from = from
      self.to = to
      self.event = Executable.new options[:event] if options.has_key?(:event)
      self.guard = Executable.new options[:guard] if options.has_key?(:guard)
    end
    
    def fire_event(target, args)
      self.event.execute(target, *args) if self.event
    end  
    
    def fire?(target, args)
      self.guard ? self.guard.execute(target, *args) : true
    end  
    
    def to_s
      "Transition from #{self.from.name} -> #{self.to.name} with event #{self.event}"
    end  
    
    def to_dot(options = {})
      "#{self.from.name} -> #{self.to.name} [label=\"#{self.name}\"]"
    end  
  end
end