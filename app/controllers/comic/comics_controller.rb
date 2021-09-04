require 'rest-client'
require_relative '../../services/comic/comic_service'
require_relative '../../http_out/comic/component'
require_relative '../../adapters/comic/comic_adapter'
require_relative '../../adapters/comic/character_adapter'

module Comic
  class ComicsController < ApplicationController

    def index
      comic_adapter = Adapters::Comic::ComicAdapter
      character_adapter = Adapters::Comic::CharacterAdapter
      @filter_params = comic_adapter.adapt_view_params(params)

      http_component = HttpOut::Comic::Component.new(RestClient, 
                                                     comic_adapter, 
                                                     character_adapter, 
                                                     @filter_params)
      comic_service = Services::Comic::ComicService.new(http_component)

      @comics = comic_service.retrieve_comics
    end
  end
end
