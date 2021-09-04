require_relative '../../entities/comic/character'

module Adapters
    module Comic
        class CharacterAdapter
            def self.adapt(character)
                character['data']['results'].map {|result|  
                    Entities::Comic::Character.new(id: result['id'], name: result['name']) 
                }.first
            end
        end
    end
end