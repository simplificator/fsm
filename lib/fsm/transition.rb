module FSM
  class Transition
    attr_accessor(:name, :from, :to, :event)
    def initialize(name, from, to, options = {})
      self.name = name
      self.from = from
      self.to = to
      self.event = Executable.new options[:event], true
    end
    
    def fire_event(target, args)
      self.event.execute(target, args)
    end    
    
    def to_s
      "Transition from #{self.from.name} -> #{self.to.name} with event #{self.event}"
    end    
  end
end