require 'legacy_dry/types/decorator'
require 'legacy_dry/types/constraints'
require 'legacy_dry/types/constrained/coercible'

module LegacyDry
  module Types
    class Constrained
      include Type
      include LegacyDry::Equalizer(:type, :options, :rule, :meta)
      include Decorator
      include Builder

      # @return [LegacyDry::Logic::Rule]
      attr_reader :rule

      # @param [Type] type
      # @param [Hash] options
      def initialize(type, options)
        super
        @rule = options.fetch(:rule)
      end

      # @param [Object] input
      # @return [Object]
      # @raise [ConstraintError]
      def call(input)
        try(input) do |result|
          raise ConstraintError.new(result, input)
        end.input
      end
      alias_method :[], :call

      # @param [Object] input
      # @param [#call,nil] block
      # @yieldparam [Failure] failure
      # @yieldreturn [Result]
      # @return [Logic::Result, Result]
      # @return [Object] if block given and try fails
      def try(input, &block)
        result = rule.(input)

        if result.success?
          type.try(input, &block)
        else
          failure = failure(input, result)
          block ? yield(failure) : failure
        end
      end

      # @param [Object] value
      # @return [Boolean]
      def valid?(value)
        rule.(value).success? && type.valid?(value)
      end

      # @param [Hash] options
      #   The options hash provided to {Types.Rule} and combined
      #   using {&} with previous {#rule}
      # @return [Constrained]
      # @see LegacyDry::Logic::Operators#and
      def constrained(options)
        with(rule: rule & Types.Rule(options))
      end

      # @return [true]
      def constrained?
        true
      end

      # @param [Object] value
      # @return [Boolean]
      def ===(value)
        valid?(value)
      end

      # @api public
      #
      # @see Definition#to_ast
      def to_ast(meta: true)
        [:constrained, [type.to_ast(meta: meta),
                        rule.to_ast,
                        meta ? self.meta : EMPTY_HASH]]
      end

      private

      # @param [Object] response
      # @return [Boolean]
      def decorate?(response)
        super || response.kind_of?(Constructor)
      end
    end
  end
end
