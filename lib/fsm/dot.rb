module FSM
  module Dot
    def self.included(includer)
      includer.class_eval do 
        include(InstanceMethods)
      end
    end
    
    module InstanceMethods
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
  end
end