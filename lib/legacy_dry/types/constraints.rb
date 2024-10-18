require 'legacy_dry/logic/rule_compiler'
require 'legacy_dry/logic/predicates'
require 'legacy_dry/logic/rule/predicate'

module LegacyDry
  module Types
    # @param [Hash] options
    # @return [LegacyDry::Logic::Rule]
    def self.Rule(options)
      rule_compiler.(
        options.map { |key, val| Logic::Rule::Predicate.new(Logic::Predicates[:"#{key}?"]).curry(val).to_ast }
      ).reduce(:and)
    end

    # @return [LegacyDry::Logic::RuleCompiler]
    def self.rule_compiler
      @rule_compiler ||= Logic::RuleCompiler.new(Logic::Predicates)
    end
  end
end
