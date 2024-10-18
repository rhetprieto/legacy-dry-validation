require 'dry/logic/predicates'

module LegacyDry
  module Validation
    module Predicates
      include Dry::Logic::Predicates

      class << self
        undef :nil?
      end

      define_singleton_method :nil?, &Object.method(:nil?)

      def self.none?(input)
        input.nil?
      end
    end
  end
end
