# frozen_string_literal: true

require "legacy_dry/container/item/memoizable"
require "legacy_dry/container/item/callable"

module LegacyDry
  class Container
    class Item
      # Factory for create an Item to register inside of container
      #
      # @api public
      class Factory
        # Creates an Item Memoizable or Callable
        # @param [Mixed] item
        # @param [Hash] options
        #
        # @raise [LegacyDry::Container::Error]
        #
        # @return [LegacyDry::Container::Item::Base]
        def call(item, options = {})
          options[:memoize] ? Memoizable.new(item, options) : Callable.new(item, options)
        end
      end
    end
  end
end
