# frozen_string_literal: true

module LegacyDry
  class Container
    # Create a namespace to be imported
    #
    # @example
    #
    #   ns = LegacyDry::Container::Namespace.new('name') do
    #     register('item', 'item')
    #   end
    #
    #   container = LegacyDry::Container.new
    #
    #   container.import(ns)
    #
    #   container.resolve('name.item')
    #   => 'item'
    #
    #
    # @api public
    class Namespace
      # @return [Mixed] The namespace (name)
      attr_reader :name
      # @return [Proc] The block to be executed when the namespace is imported
      attr_reader :block
      # Create a new namespace
      #
      # @param [Mixed] name
      #   The name of the namespace
      # @yield
      #   The block to evaluate when the namespace is imported
      #
      # @return [LegacyDry::Container::Namespace]
      #
      # @api public
      def initialize(name, &block)
        @name = name
        @block = block
      end
    end
  end
end
