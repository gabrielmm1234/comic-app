require 'dry-struct'

module Types
    include Dry.Types()
end

module Entities
    module Comic
        class Comic < Dry::Struct
            attribute :id,      Types::Integer
            attribute :title,   Types::String
            attribute :image,   Types::String
            attribute :checked, Types::Bool.default(false)

            def check!(upvoted)
                return self.new(checked: true) if upvoted.include?(self.id)
                return self
            end
        end
    end
end