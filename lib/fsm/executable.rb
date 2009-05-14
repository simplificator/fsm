module FSM
  #
  # Execute an action specified by either String, Sylbol or Proc.
  # Symbol and String represent methods which are called on the target object, Proc will get executed 
  # and receives at least the target as parameter
  class Executable
    # Create a new Executable
    # if args is true, then arguments are passed on to the target method or the Proc, if false nothing 
    # will get passed
    def initialize(thing, args = false)
      @thing = thing
      @has_arguments = args
    end
    
    # execute this executable on the given target
    def execute(target, args)
      case @thing
      when String, Symbol:
        @has_arguments ? target.send(@thing, *args) : target.send(@thing)
      when Proc:
        @has_arguments ? @thing.call(target, *args) : @thing.call(target)
      when Nil:
      else
        raise "Unknown Thing #{@thing}"
      end
    end
  end
end