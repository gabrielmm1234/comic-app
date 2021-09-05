module Services
    module Comic
        class ComicService
            def initialize(http_component: nil, db_component: nil)
                @http = http_component
                @db_component = db_component
            end

            def retrieve_comics
                character = @http.get_character
                comics = @http.get_comics(character)
            end

            def vote_comic(vote_command)
                if vote_command.vote_type == "up"
                    db_component.upvote(vote_command)
                elsif vote_command.vote_type == "down"
                    db_component.downvote(vote_command)
                end
            end
        end
    end
end