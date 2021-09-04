module Services
    module Comic
        class ComicService
            def initialize(http_component)
                @http = http_component
            end

            def retrieve_comics
                character = @http.get_character
                comics = @http.get_comics(character)
            end
        end
    end
end