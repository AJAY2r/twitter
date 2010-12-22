module Twitter
  class Geo
    extend SingleForwardable

    def initialize(options={})
      @adapter = options.delete(:adapter)
      @api_endpoint = "api.twitter.com/#{Twitter.api_version}/geo"
      @api_endpoint = Addressable::URI.heuristic_parse(@api_endpoint)
      @api_endpoint = @api_endpoint.to_s
    end

    def place(place_id, options={})
      results = connection.get do |request|
        request.url "id/#{place_id}.json", options
      end.body
    end

    def search(options={})
      results = connection.get do |request|
        request.url "search.json", options
      end.body
    end

    def reverse_geocode(options={})
      results = connection.get do |request|
        request.url "reverse_geocode.json", options
      end.body
    end
    
    def similar_places(options={})
      results = connection.get do |request|
        request.url "similar_places.json", options
      end.body
    end

    def self.client; self.new end

    def_delegators :client, :place, :search, :reverse_geocode, :similar_places

    def connection
      headers = {
        :user_agent => Twitter.user_agent
      }
      @connection ||= Faraday::Connection.new(:url => @api_endpoint, :headers => headers) do |builder|
        builder.adapter(@adapter || Faraday.default_adapter)
        builder.use Faraday::Response::Parse
        builder.use Faraday::Response::Mashify
      end
    end

  end
end
