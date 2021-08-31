require 'digest/md5'
module HttpOut
    module Comic
        class Component
            COMICS_AMOUNT = 50
            FORMAT_TYPE = 'comic'
            FORMAT = 'comic'
            ORDER_BY = 'onsaleDate'
            
            def initialize(rest_client, comic_adapter)
                @rest_client = rest_client
                @base_url = 'https://gateway.marvel.com:443'
                @public_key = ENV['MARVEL_PUBLIC_KEY']
                @private_key = ENV['MARVEL_PRIVATE_KEY']
                @timestamp = DateTime.now.strftime("%Q")
                @hash = Digest::MD5.hexdigest(@timestamp + @private_key + @public_key)

                @comic_adapter = comic_adapter
            end

            def get_comics
                begin
                    comics = @rest_client.get build_url("/v1/public/comics?apikey=#{@public_key}&hash=#{@hash}&ts=#{@timestamp}&format=#{FORMAT}&formatType=#{FORMAT_TYPE}&orderBy=#{ORDER_BY}&limit=#{COMICS_AMOUNT}")
                rescue RestClient::RequestFailed => error
                    puts error.response #treat better the error
                else
                    @comic_adapter.adapt(JSON.parse(comics.body))
                end
            end

            private

            def build_url(url)
                @base_url + url
            end
        end
    end
end