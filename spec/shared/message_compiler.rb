RSpec.shared_context :message_compiler do
  subject(:compiler) { LegacyDry::Validation::MessageCompiler.new(messages) }

  let(:messages) do
    LegacyDry::Validation::Messages.default
  end

  let(:result) do
    compiler.public_send(visitor, node)
  end
end
