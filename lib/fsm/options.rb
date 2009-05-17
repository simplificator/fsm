module FSM
  module Options
    module InstanceMethods
      def assert_options(options, optional_keys = {}, mandatory_keys = {})
        keys_processed = []
        mandatory_keys.each do |key|
          raise ArgumentError.new("Mandatory Key #{key} is missing") unless options.keys.include?(key)
          keys_processed << key
        end
        options.keys.each do |key|
          raise ArgumentError.new("Unsupported key #{key}") unless optional_keys.include?(key) || mandatory_keys.include?(key)
        end
      end 
    end
    
  end
end