require 'legacy_dry/validation/schema'
require 'legacy_dry/validation/schema/params'
require 'legacy_dry/types/compat/form_types'

module LegacyDry
  module Validation
    Schema::Form = Schema::Params
  end
end
