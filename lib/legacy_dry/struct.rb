require 'dry-types'
require 'dry-equalizer'
require 'legacy_dry/core/extensions'
require 'legacy_dry/core/constants'

require 'legacy_dry/struct/version'
require 'legacy_dry/struct/errors'
require 'legacy_dry/struct/class_interface'
require 'legacy_dry/struct/hashify'
require 'legacy_dry/struct/struct_builder'

module LegacyDry
  # Constructor method for easily creating a {LegacyDry::Struct}.
  # @return [LegacyDry::Struct]
  # @example
  #   require 'dry-struct'
  #
  #   module Types
  #     include LegacyDry::Types.module
  #   end
  #
  #   Person = Dry.Struct(name: Types::Strict::String, age: Types::Strict::Int)
  #   matz = Person.new(name: "Matz", age: 52)
  #   matz.name #=> "Matz"
  #   matz.age #=> 52
  #
  #   Test = Dry.Struct(expected: Types::Strict::String) { input(input.strict) }
  #   Test[expected: "foo", unexpected: "bar"]
  #   #=> LegacyDry::Struct::Error: [Test.new] unexpected keys [:unexpected] in Hash input
  def self.Struct(attributes = LegacyDry::Core::Constants::EMPTY_HASH, &block)
    Class.new(LegacyDry::Struct) do
      attributes.each { |a, type| attribute a, type }
      instance_eval(&block) if block
    end
  end

  # Typed {Struct} with virtus-like DSL for defining schema.
  #
  # ### Differences between dry-struct and virtus
  #
  # {Struct} look somewhat similar to [Virtus][] but there are few significant differences:
  #
  # * {Struct}s don't provide attribute writers and are meant to be used
  #   as "data objects" exclusively.
  # * Handling of attribute values is provided by standalone type objects from
  #   [`dry-types`][].
  # * Handling of attribute hashes is provided by standalone hash schemas from
  #   [`dry-types`][].
  # * Struct classes quack like [`dry-types`][], which means you can use them
  #   in hash schemas, as array members or sum them
  #
  # {Struct} class can specify a constructor type, which uses [hash schemas][]
  # to handle attributes in `.new` method.
  #
  # [`dry-types`]: https://github.com/dry-rb/dry-types
  # [Virtus]: https://github.com/solnic/virtus
  # [hash schemas]: http://dry-rb.org/gems/dry-types/hash-schemas
  #
  # @example
  #   require 'dry-struct'
  #
  #   module Types
  #     include LegacyDry::Types.module
  #   end
  #
  #   class Book < LegacyDry::Struct
  #     attribute :title, Types::Strict::String
  #     attribute :subtitle, Types::Strict::String.optional
  #   end
  #
  #   rom_n_roda = Book.new(
  #     title: 'Web Development with ROM and Roda',
  #     subtitle: nil
  #   )
  #   rom_n_roda.title #=> 'Web Development with ROM and Roda'
  #   rom_n_roda.subtitle #=> nil
  #
  #   refactoring = Book.new(
  #     title: 'Refactoring',
  #     subtitle: 'Improving the Design of Existing Code'
  #   )
  #   refactoring.title #=> 'Refactoring'
  #   refactoring.subtitle #=> 'Improving the Design of Existing Code'
  class Struct
    extend LegacyDry::Core::Extensions
    include LegacyDry::Core::Constants
    extend ClassInterface

    include LegacyDry::Equalizer(:__attributes__)

    # {LegacyDry::Types::Hash::Schema} subclass with specific behaviour defined for
    # @return [LegacyDry::Types::Hash::Schema]
    defines :input
    input Types['coercible.hash'].schema(EMPTY_HASH)

    @meta = EMPTY_HASH

    # @!attribute [Hash{Symbol => Object}] attributes
    attr_reader :attributes
    alias_method :__attributes__, :attributes

    # @param [Hash, #each] attributes
    def initialize(attributes)
      @attributes = attributes
    end

    # Retrieves value of previously defined attribute by its' `name`
    #
    # @param [String] name
    # @return [Object]
    #
    # @example
    #   class Book < LegacyDry::Struct
    #     attribute :title, Types::Strict::String
    #     attribute :subtitle, Types::Strict::String.optional
    #   end
    #
    #   rom_n_roda = Book.new(
    #     title: 'Web Development with ROM and Roda',
    #     subtitle: nil
    #   )
    #   rom_n_roda[:title] #=> 'Web Development with ROM and Roda'
    #   rom_n_roda[:subtitle] #=> nil
    def [](name)
      @attributes.fetch(name) { raise MissingAttributeError.new(name) }
    end

    # Converts the {LegacyDry::Struct} to a hash with keys representing
    # each attribute (as symbols) and their corresponding values
    #
    # @return [Hash{Symbol => Object}]
    #
    # @example
    #   class Book < LegacyDry::Struct
    #     attribute :title, Types::Strict::String
    #     attribute :subtitle, Types::Strict::String.optional
    #   end
    #
    #   rom_n_roda = Book.new(
    #     title: 'Web Development with ROM and Roda',
    #     subtitle: nil
    #   )
    #   rom_n_roda.to_hash
    #     #=> {title: 'Web Development with ROM and Roda', subtitle: nil}
    def to_hash
      self.class.schema.keys.each_with_object({}) do |key, result|
        result[key] = Hashify[self[key]] if attributes.key?(key)
      end
    end
    alias_method :to_h, :to_hash

    # Create a copy of {LegacyDry::Struct} with overriden attributes
    #
    # @param [Hash{Symbol => Object}] changeset
    #
    # @return [Struct]
    #
    # @example
    #   class Book < LegacyDry::Struct
    #     attribute :title, Types::Strict::String
    #     attribute :subtitle, Types::Strict::String.optional
    #   end
    #
    #   rom_n_roda = Book.new(
    #     title: 'Web Development with ROM and Roda',
    #     subtitle: '2nd edition'
    #   )
    #     #=> #<Book title="Web Development with ROM and Roda" subtitle="2nd edition">
    #
    #   rom_n_roda.new(subtitle: '3nd edition')
    #     #=> #<Book title="Web Development with ROM and Roda" subtitle="3nd edition">
    def new(changeset)
      self.class[__attributes__.merge(changeset)]
    end
    alias_method :__new__, :new

    # @return [String]
    def inspect
      klass = self.class
      attrs = klass.attribute_names.map { |key| " #{key}=#{@attributes[key].inspect}" }.join
      "#<#{ klass.name || klass.inspect }#{ attrs }>"
    end
  end
end

require 'legacy_dry/struct/value'
require 'legacy_dry/struct/extensions'
