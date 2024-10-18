# frozen_string_literal: true

require 'legacy_dry/monads'
require 'legacy_dry/monads/registry'

module LegacyDry
  module Monads
    known_monads.each { |m| load_monad(m) }
    extend(*constructors)
  end
end
