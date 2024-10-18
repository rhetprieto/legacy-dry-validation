require 'pathname'
require 'concurrent/map'

require 'legacy_dry/equalizer'
require 'dry/configurable'

require 'legacy_dry/validation/template'

module LegacyDry
  module Validation
    module Messages
      class Abstract
        extend Dry::Configurable
        include LegacyDry::Equalizer(:config)

        DEFAULT_PATH = Pathname(__dir__).join('../../../../config/errors.yml').realpath.freeze

        setting :paths, default: [DEFAULT_PATH]
        setting :root, default: 'errors'.freeze
        setting :lookup_options, default: [:root, :predicate, :rule, :val_type, :arg_type].freeze

        setting :lookup_paths, default: %w(
          %{root}.rules.%{rule}.%{predicate}.arg.%{arg_type}
          %{root}.rules.%{rule}.%{predicate}
          %{root}.%{predicate}.%{message_type}
          %{root}.%{predicate}.value.%{rule}.arg.%{arg_type}
          %{root}.%{predicate}.value.%{rule}
          %{root}.%{predicate}.value.%{val_type}.arg.%{arg_type}
          %{root}.%{predicate}.value.%{val_type}
          %{root}.%{predicate}.arg.%{arg_type}
          %{root}.%{predicate}
        ).freeze

        setting :arg_type_default, default: 'default'.freeze
        setting :val_type_default, default: 'default'.freeze

        setting :arg_types, default: Hash.new { |*| config.arg_type_default }.update(
          Range => 'range'
        )

        setting :val_types, default: Hash.new { |*| config.val_type_default }.update(
          Range => 'range',
          String => 'string'
        )

        CACHE_KEYS = %i[path message_type val_type arg_type locale].freeze

        def self.cache
          @cache ||= Concurrent::Map.new { |h, k| h[k] = Concurrent::Map.new }
        end

        attr_reader :config

        def initialize
          @config = self.class.config
        end

        def hash
          @hash ||= config.hash
        end

        def rule(name, options = {})
          path = "%{locale}.rules.#{name}"
          get(path, options) if key?(path, options)
        end

        def call(predicate, options = EMPTY_HASH)
          cache.fetch_or_store([predicate, options.reject { |k,| k.equal?(:input) }]) do
            path, opts = lookup(predicate, options)
            return unless path
            text = yield(path, opts)
            Template[text]
          end
        end
        alias_method :[], :call

        def lookup(predicate, options = {})
          tokens = options.merge(
            root: root,
            predicate: predicate,
            arg_type: config.arg_types[options[:arg_type]],
            val_type: config.val_types[options[:val_type]],
            message_type: options[:message_type] || :failure
          )

          tokens[:rule] = predicate unless tokens.key?(:rule)

          opts = options.select { |k, _| !config.lookup_options.include?(k) }

          path = lookup_paths(tokens).detect do |key|
            key?(key, opts) && get(key, opts).is_a?(String)
          end

          [path, opts]
        end

        def lookup_paths(tokens)
          config.lookup_paths.map { |path| path % tokens }
        end

        def namespaced(namespace)
          Messages::Namespaced.new(namespace, self)
        end

        def root
          config.root
        end

        def cache
          @cache ||= self.class.cache[self]
        end

        def default_locale
          :en
        end
      end
    end
  end
end
