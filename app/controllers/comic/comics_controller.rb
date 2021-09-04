require 'rest-client'
require_relative '../../services/comic/comic_service'
require_relative '../../http_out/comic/component'
require_relative '../../adapters/comic/comic_adapter'
require_relative '../../adapters/comic/character_adapter'

module Comic
  class ComicsController < ApplicationController
    before_action :set_page, only: [:index]
    before_action :set_name, only: [:index]


    INITIAL_PAGE = 0
    
    def index
      comic_adapter = Adapters::Comic::ComicAdapter
      character_adapter = Adapters::Comic::CharacterAdapter
      http_component = HttpOut::Comic::Component.new(RestClient, 
                                                     comic_adapter, 
                                                     character_adapter, 
                                                     @page, 
                                                     @name)
      
      comic_service = Services::Comic::ComicService.new(http_component)

      @comics = comic_service.retrieve_comics
    end

    private

    def set_name
      @name = params['name']
    end

    def set_page
      page_param = params['page'].to_i

      if page_param.positive?
        @page = page_param 
      else
        @page = INITIAL_PAGE
      end
    end
  end
end
