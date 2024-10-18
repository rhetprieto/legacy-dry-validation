require_relative 'suite'
require 'hotch'

Hotch() do
  1000.times do
    LegacyDry::Validation.Schema do
      configure { config.messages = :i18n }

      required(:email).filled
      required(:age).filled(:int?, gt?: 18)
      required(:address).filled(:hash?)
    end
  end
end
