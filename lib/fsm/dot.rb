module FSM
  module Dot
    def self.included(includer)
      FSM::Machine.class_eval do 
        include(MachineInstanceMethods)
      end
      FSM::State.class_eval do 
        include(StateInstanceMethods)
      end
    end
    
    module MachineInstanceMethods
      # Convert this state machine to the dot format of graphviz
      def to_dot(options = {})
        s = self.states.map do |state|
          "  #{state.to_dot(options)};"
        end
        t = self.transitions.map do |transition|
          "  #{transition.to_dot(options)};"
        end
        "digraph FSM_#{@target_class.name} {\n#{s.join("\n")}\n\n#{t.join("\n")}\n}"
      end

      # 
      def draw_graph(options = {})
        format = options[:format] || :png
        extension = options[:extension] || format
        file_name = options[:outfile] || "#{@target_class.name.downcase}.#{extension}" 
        cmd = "dot -T#{format} -o#{file_name}"
        IO.popen cmd, 'w' do |io| 
          io.write to_dot
        end 
        raise 'dot failed' unless $?.success? 
      end      
    end
    
    module StateInstanceMethods
      def to_dot(options = {})
        if initial?
          attrs = "style=bold, label=\"#{self.name}\\n(initial)\""
        elsif final?  
          attrs = "style=bold"
        else
          attrs = ""
        end
        "#{self.name}[#{attrs}]"
      end
      
      
      # Is this state final?
      def final?
        @transitions.empty?
      end

      # Is this the initial state
      def initial?
        Machine[@target_class].initial_state_name == self.name
      end
    end
  end
end