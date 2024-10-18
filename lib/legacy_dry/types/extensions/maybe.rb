require 'legacy_dry/monads/maybe'
require 'legacy_dry/types/decorator'

module LegacyDry
  module Types
    class Maybe
      include Type
      include LegacyDry::Equalizer(:type, :options)
      include Decorator
      include Builder
      include LegacyDry::Monads::Maybe::Mixin

      # @param [LegacyDry::Monads::Maybe, Object] input
      # @return [LegacyDry::Monads::Maybe]
      def call(input = Undefined)
        case input
        when LegacyDry::Monads::Maybe
          input
        when Undefined
          None()
        else
          Maybe(type[input])
        end
      end
      alias_method :[], :call

      # @param [Object] input
      # @return [Result::Success]
      def try(input = Undefined)
        res = if input.equal?(Undefined)
                None()
              else
                Maybe(type[input])
              end

        Result::Success.new(res)
      end

      # @return [true]
      def default?
        true
      end

      # @param [Object] value
      # @see LegacyDry::Types::Builder#default
      # @raise [ArgumentError] if nil provided as default value
      def default(value)
        if value.nil?
          raise ArgumentError, "nil cannot be used as a default of a maybe type"
        else
          super
        end
      end
    end

    module Builder
      # @return [Maybe]
      def maybe
        Maybe.new(Types['strict.nil'] | self)
      end
    end

    # Register non-coercible maybe types
    NON_NIL.each_key do |name|
      register("maybe.strict.#{name}", self["strict.#{name}"].maybe)
    end

    # Register coercible maybe types
    COERCIBLE.each_key do |name|
      register("maybe.coercible.#{name}", self["coercible.#{name}"].maybe)
    end
  end
end
