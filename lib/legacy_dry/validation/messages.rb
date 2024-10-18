module LegacyDry
  module Validation
    module Messages
      def self.default
        Messages::YAML.load
      end
    end
  end
end

require 'legacy_dry/validation/messages/abstract'
require 'legacy_dry/validation/messages/namespaced'
require 'legacy_dry/validation/messages/yaml'
require 'legacy_dry/validation/messages/i18n' if defined?(I18n)
