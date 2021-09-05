require 'rails_helper'
require_relative '../../../app/http_out/comic/component'
require_relative '../../../app/adapters/comic/comic_adapter'
require_relative '../../../app/adapters/comic/character_adapter'

describe HttpOut::Comic::Component do
  context 'when communicating with marvel api' do
    context 'when searching for comics' do
        it 'returns comics based on parameters' do
            rest_client = double("rest_client")
            comic_adapter = Adapters::Comic::ComicAdapter
            character_adapter = Adapters::Comic::CharacterAdapter
            filter_params = OpenStruct.new(name: nil, page: 0)
            character = nil
    
            comics = [{title: "deadpool", thumbnail: {path: "thumbnail-1.com", extension: "jpg"}},
                      {title: "hulk", thumbnail: {path: "thumbnail-2.com", extension: "jpg"}}]
            response = OpenStruct.new(body: {data: {results: comics}}.to_json)
            expect(rest_client).to receive(:get).and_return(response)
    
            first_comic = Entities::Comic::Comic.new(title: "deadpool",
                                                     image: "thumbnail-1.com/portrait_fantastic.jpg")
            second_comic = Entities::Comic::Comic.new(title: "hulk",
                                                      image: "thumbnail-2.com/portrait_fantastic.jpg")
            expected_result = [first_comic, second_comic]
    
            http_component = described_class.new(rest_client, 
                                                 comic_adapter, 
                                                 character_adapter, 
                                                 filter_params)
            internal_comics = http_component.get_comics(character)
    
            expect(internal_comics.length).to be 2
            expect(internal_comics).to eql expected_result
        end
    end

    context 'when searching for character' do
        it 'returns nil when not search for specific character' do
            rest_client = double("rest_client")
            comic_adapter = Adapters::Comic::ComicAdapter
            character_adapter = Adapters::Comic::CharacterAdapter
            filter_params = OpenStruct.new(name: nil, page: 0)
            
            expect(rest_client).to_not receive(:get)

            expected_result = nil
    
            http_component = described_class.new(rest_client, 
                                                 comic_adapter, 
                                                 character_adapter, 
                                                 filter_params)
            internal_character = http_component.get_character
    
            expect(internal_character).to be nil
        end

        it 'returns character when filtering by name' do
            rest_client = double("rest_client")
            comic_adapter = Adapters::Comic::ComicAdapter
            character_adapter = Adapters::Comic::CharacterAdapter
            filter_params = OpenStruct.new(name: "deadpool", page: 0)
            character = Entities::Comic::Character.new(id: 1,
                                                       name: "deadpool")

            comics = [{id: 1, name: "deadpool"}]
            response = OpenStruct.new(body: {data: {results: comics}}.to_json)
            expect(rest_client).to receive(:get).and_return(response)

            expected_result = character
    
            http_component = described_class.new(rest_client, 
                                                 comic_adapter, 
                                                 character_adapter, 
                                                 filter_params)
            internal_character = http_component.get_character
    
            expect(internal_character).to eql expected_result
        end
    end
  end
end