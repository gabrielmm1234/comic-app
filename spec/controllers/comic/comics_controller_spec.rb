require 'rails_helper'
require_relative '../../../app/controllers/comic/comics_controller.rb'
require_relative '../../../app/entities/comic/comic'


describe Comic::ComicsController, type: :controller do
    context "GET index" do
        it "returns a successful response" do
            comic = { id: 1, title: 'deadpool', thumbnail: { path: 'thumbnail-1.com', extension: 'jpg' } }
            expected_comic = Entities::Comic::Comic.new(id: 1,
                                                     title: 'deadpool',
                                                     image: 'thumbnail-1.com/portrait_fantastic.jpg')
            api_response = instance_double(RestClient::Response,
                                 body: {
                                   'data' => {'results' => [comic]},
                                 }.to_json)
            allow(RestClient).to receive(:get).and_return(api_response)
            
            get :index, params: { name: '', page: 0 }
            
            expect(response).to be_successful
            expect(assigns(:comics)).to eql [expected_comic]
        end
    end

    context "POST vote" do
        it "process an upvote correctly" do
            expected_body = {comic_id: '1'}.to_json
            post :vote, params: { comic_id: '1', vote_type: 'up' }
            
            expect(response).to be_successful
            expect(response.body).to eql expected_body
        end

        it "process a downvote correctly" do
            expected_body = {comic_id: '1'}.to_json
            post :vote, params: { comic_id: '1', vote_type: 'down' }
            
            expect(response).to be_successful
            expect(response.body).to eql expected_body
        end

        it "process up and down vote correctly" do
            expected_body = {comic_id: '1'}.to_json
            post :vote, params: { comic_id: '1', vote_type: 'up' }
            post :vote, params: { comic_id: '1', vote_type: 'down' }
            
            expect(response).to be_successful
            expect(response.body).to eql expected_body
        end
    end
end