RSpec.describe LegacyDry::Validation::Schema, 'defining schema using legacy_dry struct' do
  before do
    LegacyDry::Validation.load_extensions(:struct)
  end

  subject(:schema) do
    LegacyDry::Validation.Schema do
      required(:person).filled(Test::Person)
    end
  end

  before do
    class Test::Name < LegacyDry::Struct::Value
      attribute :given_name, LegacyDry::Types['strict.string']
      attribute :family_name, LegacyDry::Types['strict.string']
    end

    class Test::Person < LegacyDry::Struct::Value
      attribute :name, Test::Name
    end
  end

  it 'handles nested structs' do
    expect(schema.call(person: { name: { given_name: 'Tim', family_name: 'Cooper' } })).to be_success
  end

  it 'fails when input is not valid' do
    expect(schema.call(person: { name: { given_name: 'Tim' } }).messages).to eq(
      person: { name: { family_name: ['is missing', 'must be String'] } }
    )
  end
end
