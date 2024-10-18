require 'bigdecimal'
require 'date'
require 'set'

require 'concurrent'

require 'dry-container'
require 'legacy_dry/equalizer'
require 'legacy_dry/core/extensions'
require 'legacy_dry/core/constants'
require 'legacy_dry/core/class_attributes'

require 'legacy_dry/types/version'
require 'legacy_dry/types/container'
require 'legacy_dry/types/inflector'
require 'legacy_dry/types/type'
require 'legacy_dry/types/definition'
require 'legacy_dry/types/constructor'
require 'legacy_dry/types/builder_methods'

require 'legacy_dry/types/errors'

module LegacyDry
  module Types
    extend LegacyDry::Core::Extensions
    extend LegacyDry::Core::ClassAttributes
    include LegacyDry::Core::Constants

    # @!attribute [r] namespace
    #   @return [Container{String => Definition}]
    defines :namespace

    namespace self

    TYPE_SPEC_REGEX = %r[(.+)<(.+)>].freeze

    # @return [Module]
    def self.module
      namespace = Module.new
      define_constants(namespace, type_keys)
      namespace.extend(BuilderMethods)
      namespace
    end

    # @deprecated Include {LegacyDry::Types.module} instead
    def self.finalize
      warn 'LegacyDry::Types.finalize and configuring namespace is deprecated. Just'\
       ' do `include LegacyDry::Types.module` in places where you want to have access'\
       ' to built-in types'

      define_constants(self.namespace, type_keys)
    end

    # @return [Container{String => Definition}]
    def self.container
      @container ||= Container.new
    end

    # @api private
    def self.registered?(class_or_identifier)
      container.key?(identifier(class_or_identifier))
    end

    # @param [String] name
    # @param [Type] type
    # @param [#call,nil] block
    # @return [Container{String => Definition}]
    # @api private
    def self.register(name, type = nil, &block)
      container.register(name, type || block.call)
    end

    # @param [String,Class] name
    # @return [Type,Class]
    def self.[](name)
      type_map.fetch_or_store(name) do
        case name
        when String
          result = name.match(TYPE_SPEC_REGEX)

          if result
            type_id, member_id = result[1..2]
            container[type_id].of(self[member_id])
          else
            container[name]
          end
        when Class
          type_name = identifier(name)

          if container.key?(type_name)
            self[type_name]
          else
            name
          end
        end
      end
    end

    # @param [Module] namespace
    # @param [<String>] identifiers
    # @return [<Definition>]
    def self.define_constants(namespace, identifiers)
      names = identifiers.map do |id|
        parts = id.split('.')
        [Inflector.camelize(parts.pop), parts.map(&Inflector.method(:camelize))]
      end

      names.map do |(klass, parts)|
        mod = parts.reduce(namespace) do |a, e|
          a.constants.include?(e.to_sym) ? a.const_get(e) : a.const_set(e, Module.new)
        end

        mod.const_set(klass, self[identifier((parts + [klass]).join('::'))])
      end
    end

    # @param [#to_s] klass
    # @return [String]
    def self.identifier(klass)
      Inflector.underscore(klass).tr('/', '.')
    end

    # @return [Concurrent::Map]
    def self.type_map
      @type_map ||= Concurrent::Map.new
    end

    # List of type keys defined in {LegacyDry::Types.container}
    # @return [<String>]
    def self.type_keys
      container.keys
    end

    private

    # @api private
    def self.const_missing(const)
      underscored = Inflector.underscore(const)

      if type_keys.any? { |key| key.split('.')[0] == underscored }
        raise NameError,
              'dry-types does not define constants for default types. '\
              'You can access the predefined types with [], e.g. LegacyDry::Types["strict.integer"] '\
              'or generate a module with types using LegacyDry::Types.module'
      else
        super
      end
    end
  end
end

require 'legacy_dry/types/core' # load built-in types
require 'legacy_dry/types/extensions'
