require 'legacy_dry/validation/schema'
require 'legacy_dry/types/params'

module LegacyDry
  module Validation
    class Schema::Params < Schema
      def self.configure(klass = nil, &block)
        if klass
          klass.configure do |config|
            config.input_processor = :params
            config.hash_type = :symbolized
          end
          klass
        else
          super(&block)
        end
      end

      configure(self)
    end
  end
end
