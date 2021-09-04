require 'dry-struct'

module Types
    include Dry.Types()
end

module Entities
    module Comic
        class Character < Dry::Struct
            attribute :id, Types::Integer
            attribute :name, Types::String
        end
    end
end