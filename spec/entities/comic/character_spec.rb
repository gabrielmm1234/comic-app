require 'rails_helper'
require_relative '../../../app/entities/comic/character'

describe Entities::Comic::Character do
  context 'when creating a character entity' do
    it 'returns a valid character entity' do
      character = described_class.new(id: 1, name: 'deadpool')

      expect(character.id).to be 1
      expect(character.name).to eq 'deadpool'
    end

    it 'throws an exception with invalid param' do
      expect { described_class.new(id: '1', name: 'deadpool') }.to raise_error(Dry::Struct::Error)
      expect { described_class.new(id: 1, name: 2) }.to raise_error(Dry::Struct::Error)
    end
  end
end
