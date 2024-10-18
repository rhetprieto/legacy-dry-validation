# frozen_string_literal: true

require 'dry/monads/validated'

module LegacyDry
  module Monads
    to_list = List::Validated.method(:pure)

    id = -> x { x }

    # List of default traverse functions for types.
    # It is implicitly used by List#traverse for
    # making common cases easier to handle.
    Traverse = {
      Validated => -> el { el.alt_map(to_list) }
    }

    # By default the identity function is used
    Traverse.default = id
    Traverse.freeze
  end
end
