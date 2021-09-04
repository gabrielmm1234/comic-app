require 'rails_helper'
require_relative '../../../app/adapters/comic/comic_adapter'
require_relative '../../../app/entities/comic/comic'

describe Adapters::Comic::ComicAdapter do
  context 'when adapting comic outside response' do
    it 'returns an internal entity representing a comic' do
        comics = [{title: "deadpool", thumbnail: {path: "thumbnail-1.com", extension: "jpg"}},
                  {title: "hulk", thumbnail: {path: "thumbnail-2.com", extension: "jpg"}}]
        api_comics = {data: {results: comics}}.with_indifferent_access
        first_comic = Entities::Comic::Comic.new(title: "deadpool",
                                                 image: "thumbnail-1.com/portrait_fantastic.jpg")
        second_comic = Entities::Comic::Comic.new(title: "hulk",
                                                  image: "thumbnail-2.com/portrait_fantastic.jpg")
        expected_result = [first_comic, second_comic]

        internal_comics = described_class.adapt(api_comics)

        expect(internal_comics.length).to be 2
        expect(internal_comics).to eql(expected_result)
    end
  end
end