require 'digest/md5'

module HttpOut
  module Comic
    class Component
      COMICS_AMOUNT = 20
      FORMAT_TYPE = 'comic'
      FORMAT = 'comic'
      ORDER_BY = '-focDate'

      def initialize(rest_client, comic_adapter, character_adapter, filter_params)
        @rest_client = rest_client
        @base_url ||= 'https://gateway.marvel.com:443'
        @public_key ||= ENV['MARVEL_PUBLIC_KEY']
        @private_key ||= ENV['MARVEL_PRIVATE_KEY']
        @timestamp = DateTime.now.strftime('%Q')
        @hash = Digest::MD5.hexdigest(@timestamp + @private_key + @public_key)

        @filter_params ||= filter_params
        @comic_adapter ||= comic_adapter
        @character_adapter ||= character_adapter
      end

      def get_comics(character)
        response = @rest_client.get build_url('/v1/public/comics'), { params: build_comic_params(character) }
        comics = JSON.parse(response.body)
      rescue RestClient::RequestFailed => e
        puts e.response
      ensure
        return @comic_adapter.adapt(comics)
      end

      def get_character
        if @filter_params.name
          begin
            response = @rest_client.get build_url('/v1/public/characters'), { params: build_character_params }
            characters = JSON.parse(response.body)
          rescue RestClient::RequestFailed => e
            puts e.response
          ensure
            return @character_adapter.adapt(characters)
          end
        end
      end

      private

      def build_comic_params(character)
        { apikey: @public_key,
          hash: @hash,
          ts: @timestamp,
          format: FORMAT,
          formatType: FORMAT_TYPE,
          orderBy: ORDER_BY,
          limit: COMICS_AMOUNT,
          offset: compute_offset,
          characters: character&.id }.delete_if { |_key, value| value.nil? }
      end

      def build_character_params
        { apikey: @public_key,
          hash: @hash,
          ts: @timestamp,
          name: @filter_params.name }
      end

      def compute_offset
        @filter_params.page * COMICS_AMOUNT
      end

      def build_url(url)
        @base_url + url
      end
    end
  end
end
