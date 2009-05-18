module FSM
  #
  # Execute an action specified by either String, Sylbol or Proc.
  # Symbol and String represent methods which are called on the target object, Proc will get executed 
  # and receives at least the target as parameter. If others parameters are passed then they'll get forwarded as well.
  class Executable
    # Create a new Executable
    # if args is true, then arguments are passed on to the target method or the Proc, if false nothing 
    # will get passed
    def initialize(thing)
      raise ArgumentError.new("Unknown thing #{thing}") unless thing
      @thing = thing
    end
    
    # execute this executable on the given target
    def execute(target, *args)
      case @thing
      when String, Symbol:
        if (args.length > 0)
          target.send(@thing, *args)
        else
          target.send(@thing)
        end
      when Proc:
        if (args.length > 0) 
          @thing.call(target, *args)
        else
          @thing.call(target)
        end
      else
        raise "Unknown Thing #{@thing}"
      end
    end
  end
end