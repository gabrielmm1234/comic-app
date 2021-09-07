require 'rails_helper'
require 'mock_redis'
require 'securerandom'
require_relative '../../../app/database/comic/component'

describe Database::Comic::Component do
    context 'when communicating with redis database' do
        it 'upvotes a comic' do
            mock_redis = MockRedis.new
            user_id = SecureRandom.uuid
            comic_id = SecureRandom.uuid
            vote_type = 'up'
            upvote_command = OpenStruct.new(user_id: user_id, 
                                            comic_id: comic_id, 
                                            vote_type: vote_type)

            described_class.new(mock_redis).upvote(upvote_command)

            expect(mock_redis.lrange(user_id, 0, -1)).to eql [comic_id]
            expect(mock_redis.get(comic_id)).to eql "1"
        end

        it 'downvotes a comic' do
            mock_redis = MockRedis.new
            user_id = SecureRandom.uuid
            comic_id = SecureRandom.uuid
            downvote_type = 'down'
            upvote_type = 'up'
            downvote_command = OpenStruct.new(user_id: user_id, 
                                            comic_id: comic_id, 
                                            vote_type: downvote_type)

            upvote_command = OpenStruct.new(user_id: user_id, 
                                            comic_id: comic_id, 
                                            vote_type: upvote_type)

            described_class.new(mock_redis).upvote(upvote_command)
            described_class.new(mock_redis).downvote(downvote_command)

            expect(mock_redis.lrange(user_id, 0, -1)).to eql []
            expect(mock_redis.get(comic_id)).to eql "0"
        end

        it 'retrieves updated comics' do
            mock_redis = MockRedis.new
            user_id = SecureRandom.uuid
            comic_id = SecureRandom.uuid
            upvote_type = 'up'

            upvote_command = OpenStruct.new(user_id: user_id, 
                                            comic_id: comic_id, 
                                            vote_type: upvote_type)

            described_class.new(mock_redis).upvote(upvote_command)
            upvoted_comics = described_class.new(mock_redis).upvoted_comics(user_id)

            expect(upvoted_comics).to eql [comic_id]
        end
    end
end