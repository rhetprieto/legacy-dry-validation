require 'legacy_dry/monads/result'

module LegacyDry
  module Validation
    class Result
      include LegacyDry::Monads::Result::Mixin

      def to_monad(options = EMPTY_HASH)
        if success?
          Success(output)
        else
          Failure(messages(options))
        end
      end
      alias_method :to_either, :to_monad
    end
  end
end
