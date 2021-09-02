require_relative '../../entities/comic/comic'

module Adapters
    module Comic
        class ComicAdapter
            def self.adapt(comics)
                comics['data']['results'].map do |result| 
                    Entities::Comic::Comic.new(title: result['title'],
                                               image: adapt_image(result['thumbnail']))
                end
            end

            def self.adapt_image(thumbnail)
                "#{thumbnail['path']}/portrait_fantastic.#{thumbnail['extension']}"
            end
        end
    end
end