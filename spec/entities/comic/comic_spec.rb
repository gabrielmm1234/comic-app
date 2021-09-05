require 'rails_helper'
require_relative '../../../app/entities/comic/comic'

describe Entities::Comic::Comic do
    context 'when creating a comic entity' do
        it 'returns a valid comic entity' do
            character = described_class.new(title: "deadpool", image: "deadpool/portrait.jpg")

            expect(character.title).to eq "deadpool"
            expect(character.image).to eq "deadpool/portrait.jpg"
        end

        it 'throws an exception with invalid param' do
            expect { described_class.new(title: 1, image: "deadpool/portrait.jpg") }.to raise_error(Dry::Struct::Error)
            expect { described_class.new(title: "deadpool", image: 2) }.to raise_error(Dry::Struct::Error)
        end
    end
end