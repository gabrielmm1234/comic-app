require 'rails_helper'
require 'securerandom'
require_relative '../../../app/adapters/comic/comic_adapter'
require_relative '../../../app/entities/comic/comic'

describe Adapters::Comic::ComicAdapter do
  context 'when adapting comic outside response' do
    it 'returns an internal entity representing a comic' do
        comics = [{id: 1, title: "deadpool", thumbnail: {path: "thumbnail-1.com", extension: "jpg"}},
                  {id: 2, title: "hulk", thumbnail: {path: "thumbnail-2.com", extension: "jpg"}}]
        api_comics = {data: {results: comics}}.with_indifferent_access
        first_comic = Entities::Comic::Comic.new(id: 1,
                                                 title: "deadpool",
                                                 image: "thumbnail-1.com/portrait_fantastic.jpg")
        second_comic = Entities::Comic::Comic.new(id: 2,
                                                  title: "hulk",
                                                  image: "thumbnail-2.com/portrait_fantastic.jpg")
        expected_result = [first_comic, second_comic]

        internal_comics = described_class.adapt(api_comics)

        expect(internal_comics.length).to be 2
        expect(internal_comics).to eql(expected_result)
    end
  end

  context 'when adapting comic filter params from view' do
    it 'returns an internal structure representing filter params' do
        params = {name: "deadpool", page: 1}.with_indifferent_access
        expected_result = OpenStruct.new(name: "deadpool", page: 1)

        view_params = described_class.adapt_view_params(params)

        expect(view_params).to eql(expected_result)
    end

    it 'adapts page param to be always greater than zero' do
        params = {name: "deadpool", page: -1}.with_indifferent_access
        expected_result = OpenStruct.new(name: "deadpool", page: 0)

        view_params = described_class.adapt_view_params(params)

        expect(view_params).to eql(expected_result)
    end

    it 'adapts name param to be nil when it come as empty string' do
        params = {name: "", page: 1}.with_indifferent_access
        expected_result = OpenStruct.new(name: nil, page: 1)

        view_params = described_class.adapt_view_params(params)

        expect(view_params).to eql(expected_result)
    end
  end

  context 'when adapting comic upvote params from request' do
    it 'returns an internal structure representing upvote command' do
        user_id = SecureRandom.uuid
        comic_id = 1
        vote_type = 'up'
        params = {user_id: user_id, comic_id: comic_id, vote_type: vote_type}.with_indifferent_access
        expected_result = OpenStruct.new(user_id: user_id, comic_id: comic_id, vote_type: vote_type)

        view_params = described_class.adapt_upvote_params(params, user_id)

        expect(view_params).to eql(expected_result)
    end
  end
end