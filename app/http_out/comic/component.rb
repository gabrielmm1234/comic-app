require 'digest/md5'

module HttpOut
    module Comic
        class Component
            COMICS_AMOUNT = 20
            FORMAT_TYPE = 'comic'
            FORMAT = 'comic'
            ORDER_BY = '-focDate'
            
            def initialize(rest_client, comic_adapter, character_adapter, page, name)
                @rest_client = rest_client
                @base_url ||= 'https://gateway.marvel.com:443'
                @public_key ||= ENV['MARVEL_PUBLIC_KEY']
                @private_key ||= ENV['MARVEL_PRIVATE_KEY']
                @timestamp = DateTime.now.strftime("%Q")
                @hash = Digest::MD5.hexdigest(@timestamp + @private_key + @public_key)

                @page ||= page
                @name ||= name
                @comic_adapter ||= comic_adapter
                @character_adapter ||= character_adapter
            end

            def get_comics(character_id)
                response = @rest_client.get build_url("/v1/public/comics"), {params: build_comic_params(character_id)}
                comics = JSON.parse(response.body)
            rescue RestClient::RequestFailed => error
                puts error.response #treat better the error
            ensure
                return @comic_adapter.adapt(comics)
            end

            def get_character
                response = @rest_client.get build_url("/v1/public/characters?apikey=#{@public_key}&hash=#{@hash}&ts=#{@timestamp}&name=#{@name}")
                characters = JSON.parse(response.body)
            rescue RestClient::RequestFailed => error
                characters = {data: {results: []}}.with_indifferent_access
            ensure
                return @character_adapter.adapt(characters)
            end

            private

            def build_comic_params(character_id)
                {apikey: @public_key,
                 hash: @hash,
                 ts: @timestamp,
                 format: FORMAT,
                 formatType: FORMAT_TYPE,
                 orderBy: ORDER_BY,
                 limit: COMICS_AMOUNT,
                 offset: compute_offset,
                 characters: character_id}.delete_if {|key, value|  value.nil?}
            end

            def compute_offset
                @page * COMICS_AMOUNT
            end

            def build_url(url)
                @base_url + url
            end
        end
    end
end