module Adapters
    module Comic
        class ComicAdapter
            def self.adapt(comics)
                comics['data']['results'].map {|result| result['title']}
            end
        end
    end
end