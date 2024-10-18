# frozen_string_literal: true

require "legacy_dry/container/item"

module LegacyDry
  class Container
    class Item
      # Memoizable class to store and execute item calls
      #
      # @api public
      #
      class Memoizable < Item
        # @return [Mutex] the stored mutex
        attr_reader :memoize_mutex

        # Returns a new Memoizable instance
        #
        # @param [Mixed] item
        # @param [Hash] options
        #
        # @raise [LegacyDry::Container::Error]
        #
        # @return [LegacyDry::Container::Item::Base]
        def initialize(item, options = {})
          super
          raise_not_supported_error unless callable?

          @memoize_mutex = ::Mutex.new
        end

        # Returns the result of item call using a syncronized mutex
        #
        # @return [LegacyDry::Container::Item::Base]
        def call
          memoize_mutex.synchronize do
            @memoized_item ||= item.call
          end
        end

        private

        # @private
        def raise_not_supported_error
          raise ::LegacyDry::Container::Error, "Memoize only supported for a block or a proc".freeze
        end
      end
    end
  end
end
