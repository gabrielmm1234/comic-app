module Services
    module Comic
        class ComicService
            def initialize(http_component)
                @http = http_component
            end

            def retrieve_comics
                comics = @http.get_comics
            end
        end
    end
end