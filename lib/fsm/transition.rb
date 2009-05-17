module FSM
  class Transition
    include FSM::Options::InstanceMethods
    attr_accessor(:name, :from, :to, :event)
    def initialize(name, from, to, options = {})
      raise ArgumentError.new("name, from and to are required but were '#{name}', '#{from}' and '#{to}'") unless name && from && to
      assert_options(options, [:event])
      self.name = name
      self.from = from
      self.to = to
      self.event = Executable.new options[:event]
    end
    
    def fire_event(target, args)
      self.event.execute(target, args)
    end    
    
    def to_s
      "Transition from #{self.from.name} -> #{self.to.name} with event #{self.event}"
    end    
  end
end