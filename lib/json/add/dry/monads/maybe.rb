# frozen_string_literal: false

require 'json' unless defined?(::JSON::JSON_LOADED) && ::JSON::JSON_LOADED

require 'legacy_dry/monads'

# Inspired by standard library implementation
# for Time serialization/deserialization see (json/lib/json/add/time.rb)
#
module LegacyDry
  module Monads
    class Maybe
      # Deserializes JSON string by using LegacyDry::Monads::Maybe#lift method
      def self.json_create(serialized)
        coerce(serialized.fetch('value'))
      end

      # Returns a hash, that will be turned into a JSON object and represent this
      # object.
      def as_json(*)
        {
          JSON.create_id => self.class.name,
          value: none? ? nil : @value
        }
      end

      # Stores class name (LegacyDry::Monads::Maybe::Some or LegacyDry::Monads::Maybe::None)
      # with the monad value as JSON string
      def to_json(*args)
        as_json.to_json(*args)
      end
    end
  end
end
