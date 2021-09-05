require 'rails_helper'
require_relative '../../../app/adapters/comic/character_adapter'
require_relative '../../../app/entities/comic/character'

describe Adapters::Comic::CharacterAdapter do
    context 'when adapting character outside response' do
      it 'returns an internal entity representing a character' do
          characters = [{id: 1, name: "deadpool"}]
          api_characters = {data: {results: characters}}.with_indifferent_access
          character = Entities::Comic::Character.new(id: 1,
                                                     name: "deadpool")
          expected_result = character
  
          internal_character = described_class.adapt(api_characters)
  
          expect(internal_character).to eql(expected_result)
      end

      it 'returns nil when no character is found' do
        characters = []
        api_characters = {data: {results: characters}}.with_indifferent_access
        expected_result = nil

        internal_character = described_class.adapt(api_characters)

        expect(internal_character).to eql(expected_result)
      end
    end
end