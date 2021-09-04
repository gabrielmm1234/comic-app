require 'rails_helper'
require_relative '../../../app/adapters/comic/comic_adapter'

describe Adapters::Comic::ComicAdapter do
  context 'when adapting comic outside response' do
    it 'returns an internal entity representing a comic' do
        comics = [{title: "deadpool", thumbnail: "thumbnail.com/1"},
                  {title: "hulk", thumbnail: "thumbnail.com/2"}]
        api_comics = {data: {results: comics}}.with_indifferent_access

        internal_comics = described_class.adapt(api_comics)

        expect(internal_comics.length).to be 2
    end
  end
end