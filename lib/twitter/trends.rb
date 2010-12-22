module Twitter
  class Trends
    extend SingleForwardable

    def initialize(options={})
      @adapter = options.delete(:adapter)
      @api_endpoint = "api.twitter.com/#{Twitter.api_version}/trends"
      @api_endpoint = Addressable::URI.heuristic_parse(@api_endpoint)
      @api_endpoint = @api_endpoint.to_s
    end

    # :exclude => 'hashtags' to exclude hashtags
    def current(options={})
      results = connection.get do |request|
        request.url "current.json", options
      end.body
    end

    # :exclude => 'hashtags' to exclude hashtags
    # :date => yyyy-mm-dd for specific date
    def daily(options={})
      results = connection.get do |request|
        request.url "daily.json", options
      end.body
    end

    # :exclude => 'hashtags' to exclude hashtags
    # :date => yyyy-mm-dd for specific date
    def weekly(options={})
      results = connection.get do |request|
        request.url "weekly.json", options
      end.body
    end

    def available(options={})
      connection.get do |request|
        request.url "available.json", options
      end.body
    end

    def for_location(woeid, options = {})
      connection.get do |request|
        request.url "#{woeid}.json", options
      end.body
    end

    def self.client; self.new end

    def_delegators :client, :current, :daily, :weekly, :available, :for_location

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
