if ENV['COVERAGE'] == 'true' && RUBY_ENGINE == 'ruby' && RUBY_VERSION == '2.3.1'
  require "simplecov"
  SimpleCov.start do
    add_filter '/spec/'
  end
end

begin
  require 'pry'
  require 'pry-byebug'
rescue LoadError
end

require 'legacy-dry-validation'
require 'dry/core/constants'
require 'ostruct'

SPEC_ROOT = Pathname(__dir__)

Dir[SPEC_ROOT.join('shared/**/*.rb')].each(&method(:require))
Dir[SPEC_ROOT.join('support/**/*.rb')].each(&method(:require))

include LegacyDry::Validation

module Types
  include Dry::Types.module
end

LegacyDry::Validation::Deprecations.configure do |config|
  config.logger = Logger.new(SPEC_ROOT.join('../log/deprecations.log'))
end

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.warnings = true

  config.after do
    if defined?(I18n)
      I18n.load_path = LegacyDry::Validation.messages_paths.dup
      I18n.backend.reload!
    end
  end

  config.include PredicatesIntegration

  config.before do
    module Test
      def self.remove_constants
        constants.each { |const| remove_const(const)  }
        self
      end
    end

    LegacyDry::Validation::Messages::Abstract.instance_variable_set('@cache', nil)
    LegacyDry::Validation::Messages::YAML.instance_variable_set('@cache', nil)
    LegacyDry::Validation::Messages::I18n.instance_variable_set('@cache', nil) if defined?(I18n)
  end

  config.after do
    Object.send(:remove_const, Test.remove_constants.name)
  end
end
