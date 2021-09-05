require_relative '../../entities/comic/comic'

module Adapters
    module Comic
        class ComicAdapter
            INITIAL_PAGE = 0
            
            def self.adapt(comics)
                comics['data']['results'].map do |result| 
                    Entities::Comic::Comic.new(title: result['title'],
                                               image: adapt_image(result['thumbnail']))
                end
            end

            def self.adapt_image(thumbnail)
                "#{thumbnail['path']}/portrait_fantastic.#{thumbnail['extension']}"
            end

            def self.adapt_view_params(params)
                page_param = params['page'].to_i
                name_param = params['name']
                OpenStruct.new(name: define_correct_name(name_param), 
                               page: define_correct_page(page_param))
            end

            def self.define_correct_page(page_param)
                if page_param.positive?
                    page_param 
                else
                    INITIAL_PAGE
                end
            end

            def self.define_correct_name(name_param)
                if name_param == ""
                    nil
                else
                    name_param
                end
            end

            def self.adapt_upvote_params(params, user_id)
                comic_id = params['comic_id']
                vote_type = params['vote_type']
                OpenStruct.new(user_id: user_id, comic_id: comic_id, vote_type: vote_type)
            end
        end
    end
end