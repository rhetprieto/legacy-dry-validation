# frozen_string_literal: true

module LegacyDry
  module Core
    class InvalidClassAttributeValue < StandardError
      def initialize(name, value)
        super(
          "Value #{value.inspect} is invalid for class attribute #{name.inspect}"
        )
      end
    end
  end
end
