require 'legacy_dry/types/sum'

module LegacyDry
  class Struct
    # A sum type of two or more structs
    # As opposed to LegacyDry::Types::Sum::Constrained
    # this type tries no to coerce data first.
    class Sum < LegacyDry::Types::Sum::Constrained
      # @param [Hash{Symbol => Object},LegacyDry::Struct] input
      # @yieldparam [LegacyDry::Types::Result::Failure] failure
      # @yieldreturn [LegacyDry::Types::ResultResult]
      # @return [LegacyDry::Types::Result]
      def try(input)
        if input.is_a?(Struct)
          try_struct(input) { super }
        else
          super
        end
      end

      # Build a new sum type
      # @param [LegacyDry::Types::Type] type
      # @return [LegacyDry::Types::Sum]
      def |(type)
        if type.is_a?(Class) && type <= Struct || type.is_a?(Sum)
          self.class.new(self, type)
        else
          super
        end
      end

      protected

      # @private
      def try_struct(input)
        left.try_struct(input) do
          right.try_struct(input) { yield }
        end
      end
    end
  end
end
