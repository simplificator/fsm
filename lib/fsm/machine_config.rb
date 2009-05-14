module FSM
  class MachineConfig
    CONFIG_METHODS = %w[state transition initial attribute]
    instance_methods.each do |m| 
      undef_method m unless  m == '__send__' || m == '__id__' || m == 'instance_eval'
    end
    
    def initialize(target)
      @target = target
    end
    
    def process(&block)
      instance_eval(&block)
    end
    
    def method_missing(sym, *args, &block)
      raise "Unknown config method '#{sym}'. Only #{CONFIG_METHODS.map() {|item| "'#{item}'" }.join(', ')} are known" unless CONFIG_METHODS.include?(sym.to_s)
      @target.__send__(sym, *args, &block)
    end
  end
end