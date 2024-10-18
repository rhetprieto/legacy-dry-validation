require 'dry/logic/operations/key'

module LegacyDry
  module Logic
    module Operations
      class Attr < Key
        def self.evaluator(name)
          Evaluator::Attr.new(name)
        end

        def type
          :attr
        end
      end
    end
  end
end
