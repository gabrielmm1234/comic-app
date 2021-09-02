require 'dry-struct'

module Types
    include Dry.Types()
end

module Entities
    module Comic
        class Comic < Dry::Struct
            attribute :title, Types::String
            attribute :image, Types::String
        end
    end
end