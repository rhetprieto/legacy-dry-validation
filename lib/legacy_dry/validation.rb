require 'dry/core/extensions'
require 'dry/core/constants'

module LegacyDry
  module Validation
    extend Dry::Core::Extensions
    include Dry::Core::Constants

    MissingMessageError = Class.new(StandardError)
    InvalidSchemaError = Class.new(StandardError)

    def self.messages_paths
      Messages::Abstract.config.paths
    end

    def self.Schema(base = Schema, **options, &block)
      schema_class = Class.new(base.is_a?(Schema) ? base.class : base)
      klass = schema_class.define(options.merge(schema_class: schema_class), &block)

      if options[:build] == false
        klass
      else
        klass.new
      end
    end

    def self.Params(base = nil, **options, &block)
      klass = base ? Schema::Params.configure(Class.new(base)) : Schema::Params
      Validation.Schema(klass, options, &block)
    end

    def self.JSON(base = Schema::JSON, **options, &block)
      klass = base ? Schema::JSON.configure(Class.new(base)) : Schema::JSON
      Validation.Schema(klass, options, &block)
    end
  end
end

require 'legacy_dry/validation/schema'
require 'legacy_dry/validation/schema/params'
require 'legacy_dry/validation/schema/json'
require 'legacy_dry/validation/extensions'
require 'legacy_dry/validation/version'
