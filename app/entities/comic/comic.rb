require 'dry-struct'

module Types
    include Dry.Types()
end

module Entities
    module Comic
        class Comic < Dry::Struct
            attribute :id,    Types::Integer
            attribute :title, Types::String
            attribute :image, Types::String
        end
    end
end