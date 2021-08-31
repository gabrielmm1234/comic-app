require 'rest-client'
require_relative '../../services/comic/comic_service'
require_relative '../../http_out/comic/component'
require_relative '../../adapters/comic/comic_adapter'

module Comic
  class ComicsController < ApplicationController
    def index
      comic_adapter = Adapters::Comic::ComicAdapter
      http_component = HttpOut::Comic::Component.new(RestClient, comic_adapter)
      comic_service = Services::Comic::ComicService.new(http_component)

      @comics = comic_service.retrieve_comics
    end
  end
end
