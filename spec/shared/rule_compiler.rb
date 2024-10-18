require 'legacy_dry/logic/rule_compiler'
require 'legacy_dry/logic/predicates'

RSpec.shared_context 'rule compiler' do
  let(:rule_compiler) do
    LegacyDry::Logic::RuleCompiler.new(LegacyDry::Logic::Predicates)
  end
end
