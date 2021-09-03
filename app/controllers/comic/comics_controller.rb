require 'rest-client'
require_relative '../../services/comic/comic_service'
require_relative '../../http_out/comic/component'
require_relative '../../adapters/comic/comic_adapter'

module Comic
  class ComicsController < ApplicationController
    before_action :set_page, only: [:index]

    INITIAL_PAGE = 0
    
    def index
      comic_adapter = Adapters::Comic::ComicAdapter
      http_component = HttpOut::Comic::Component.new(RestClient, comic_adapter, @page)
      
      comic_service = Services::Comic::ComicService.new(http_component)

      @comics = comic_service.retrieve_comics
    end

    private

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
