require 'legacy_dry/core/deprecations'

LegacyDry::Core::Deprecations.warn('Int type was renamed to Integer', tag: :'dry-types')

module LegacyDry
  module Types
    register('int', self['integer'])
    register('strict.int', self['strict.integer'])
    register('coercible.int', self['coercible.integer'])
    register('optional.strict.int', self['optional.strict.integer'])
    register('optional.coercible.int', self['optional.coercible.integer'])
    register('params.int', self['params.integer'])
  end
end
