require 'rest-client'
require 'securerandom'
require_relative '../../services/comic/comic_service'
require_relative '../../http_out/comic/component'
require_relative '../../database/comic/component'
require_relative '../../adapters/comic/comic_adapter'
require_relative '../../adapters/comic/character_adapter'

module Comic
  class ComicsController < ApplicationController
    before_action :setup_session

    def index
      comic_adapter = Adapters::Comic::ComicAdapter
      character_adapter = Adapters::Comic::CharacterAdapter
      @filter_params = comic_adapter.adapt_view_params(params)

      redis_component = Database::Comic::Component.new(REDIS)
      http_component = HttpOut::Comic::Component.new(RestClient, 
                                                     comic_adapter, 
                                                     character_adapter, 
                                                     @filter_params)
      comic_service = Services::Comic::ComicService.new(http_component: http_component, 
                                                        db_component:   redis_component)

      @comics = comic_service.retrieve_comics(cookies.encrypted['user_session'])
    end

    def vote
      comic_adapter = Adapters::Comic::ComicAdapter
      redis_component = Database::Comic::Component.new(REDIS)
      upvote_command = comic_adapter.adapt_upvote_params(params, cookies.encrypted['user_session'])

      comic_service = Services::Comic::ComicService.new(db_component: redis_component)
      comic_service.vote_comic(upvote_command)
      render json: {comic_id: upvote_command.comic_id}, status: :ok
    end

    private

    def setup_session
      unless cookies.encrypted['user_session']
        cookies.encrypted['user_session'] = { value: SecureRandom.uuid , expires: 30.minutes.from_now }
      end
    end
  end
end
