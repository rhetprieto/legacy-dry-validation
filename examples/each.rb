require 'byebug'
require 'legacy-dry-validation'

schema = LegacyDry::Validation.Schema do
  key(:phone_numbers).each(:str?)
end

errors = schema.call(phone_numbers: '').messages

puts errors.inspect

errors = schema.call(phone_numbers: ['123456789', 123456789]).messages

puts errors.inspect
