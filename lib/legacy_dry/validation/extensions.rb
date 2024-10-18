LegacyDry::Validation.register_extension(:monads) do
  require 'legacy_dry/validation/extensions/monads'
end

LegacyDry::Validation.register_extension(:struct) do
  require 'legacy_dry/validation/extensions/struct'
end
