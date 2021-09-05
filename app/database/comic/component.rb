module Database
    module Comic
        class Component
            def initialize(redis)
                @redis = redis
            end

            def upvote(upvote_command)
                @redis.lpush(upvote_command.user_id, upvote_command.comic_id)
                @redis.incr(upvote_command.comic_id)
            end

            def downvote(downvote_command)
                @redis.lrem(downvote_command.user_id, -1, downvote_command.comic_id)
                @redis.decr(downvote_command.comic_id)
            end
        end
    end
end