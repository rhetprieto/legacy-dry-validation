# frozen_string_literal: true

require 'dry/monads/do'

module LegacyDry
  module Monads
    module Do
      # Do::All automatically wraps methods defined in a class with an unwrapping block.
      # Similar to what `Do.for(...)` does except wraps every method so you don't have
      # to list them explicitly.
      #
      # @example annotated example
      #
      #   require 'dry/monads/do/all'
      #   require 'dry/monads/result'
      #
      #   class CreateUser
      #     include Dry::Monads::Do::All
      #     include Dry::Monads::Result::Mixin
      #
      #     def call(params)
      #       # Unwrap a monadic value using an implicitly passed block
      #       # if `validates` returns Failure, the execution will be halted
      #       values = yield validate(params)
      #       user = create_user(values)
      #       # If another block is passed to a method then takes
      #       # precedence over the unwrapping block
      #       safely_subscribe(values[:email]) { Logger.info("Already subscribed") }
      #
      #       Success(user)
      #     end
      #
      #     def validate(params)
      #       if params.key?(:email)
      #         Success(email: params[:email])
      #       else
      #         Failure(:no_email)
      #       end
      #     end
      #
      #     def create_user(user)
      #       # Here a block is passed to the method but we don't use it
      #       UserRepo.new.add(user)
      #     end
      #
      #     def safely_subscribe(email)
      #       repo = SubscriptionRepo.new
      #
      #       if repo.subscribed?(email)
      #          # This calls the logger because a block
      #          # explicitly passed from `call`
      #          yield
      #       else
      #         repo.subscribe(email)
      #       end
      #     end
      #   end
      #
      module All
        # @private
        class MethodTracker < ::Module
          attr_reader :wrappers

          def initialize(wrappers)
            super()

            @wrappers = wrappers
            tracker = self

            module_eval do
              define_method(:method_added) do |method|
                super(method)

                tracker.wrap_method(self, method)
              end

              define_method(:inherited) do |base|
                super(base)

                base.prepend(wrappers[base])
              end

              def included(base)
                super
                All.included(base)
              end
            end
          end

          def extend_object(target)
            super
            target.prepend(wrappers[target])
          end

          def wrap_method(target, method)
            Do.wrap_method(wrappers[target], method)
          end
        end

        # @api private
        def self.included(base)
          super

          wrappers = ::Hash.new { |h, k| h[k] = ::Module.new }
          tracker = MethodTracker.new(wrappers)
          base.extend(tracker)
          base.instance_methods(false).each { |m| tracker.wrap_method(base, m) }

          base.extend(InstanceMixin) unless base.is_a?(::Class)
        end

        # @api private
        module InstanceMixin
          # @api private
          def extended(object)
            super

            wrapper = ::Module.new
            object.singleton_class.prepend(wrapper)
            object.define_singleton_method(:singleton_method_added) do |method|
              super(method)

              next if method.equal?(:singleton_method_added)

              Do.wrap_method(wrapper, method)
            end
            object.singleton_class.instance_methods(false).each do |m|
              Do.wrap_method(wrapper, m)
            end
          end
        end

        extend InstanceMixin
      end
    end

    require 'dry/monads/registry'
    register_mixin(:do, Do::All)
  end
end
