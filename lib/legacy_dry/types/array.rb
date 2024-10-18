require 'legacy_dry/types/array/member'
require 'legacy_dry/core/deprecations'

module LegacyDry
  module Types
    class Array < Definition
      extend LegacyDry::Core::Deprecations[:'dry-types']

      # @param [Type] type
      # @return [Array::Member]
      def of(type)
        member =
          case type
          when String then Types[type]
          else type
          end

        Array::Member.new(primitive, **options, member: member)
      end
    end
  end
end
