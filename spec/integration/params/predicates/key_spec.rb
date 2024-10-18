RSpec.describe 'Predicates: Key' do
  context 'with required' do
    it "raises error" do
      expect { LegacyDry::Validation.Params { required(:foo) { key? } } }.to raise_error InvalidSchemaError
    end
  end

  context 'with optional' do
    it "raises error" do
      expect { LegacyDry::Validation.Params { optional(:foo) { key? } } }.to raise_error InvalidSchemaError
    end
  end

  context 'as macro' do
    context 'with required' do
      context 'with value' do
        it "raises error" do
          expect { LegacyDry::Validation.Params do
            required(:foo).value(:key?)
          end }.to raise_error InvalidSchemaError
        end
      end

      context 'with filled' do
        it "raises error" do
          expect { LegacyDry::Validation.Params do
            required(:foo).filled(:key?)
          end }.to raise_error InvalidSchemaError
        end
      end

      context 'with maybe' do
        it "raises error" do
          expect { LegacyDry::Validation.Params do
            required(:foo).maybe(:key?)
          end }.to raise_error InvalidSchemaError
        end
      end
    end

    context 'with optional' do
      context 'with value' do
        it "raises error" do
          expect { LegacyDry::Validation.Schema do
            optional(:foo).value(:key?)
          end }.to raise_error InvalidSchemaError
        end
      end

      context 'with filled' do
        it "raises error" do
          expect { LegacyDry::Validation.Schema do
            optional(:foo).filled(:key?)
          end }.to raise_error InvalidSchemaError
        end
      end

      context 'with maybe' do
        it "raises error" do
          expect { LegacyDry::Validation.Schema do
            optional(:foo).maybe(:key?)
          end }.to raise_error InvalidSchemaError
        end
      end
    end
  end
end
