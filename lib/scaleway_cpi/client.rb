require 'faraday'

class ScalewayCPI::Client
  def initialize(token:)
    @token = token

    @connection = Faraday.new({url: 'https://api.cloud.online.net'}) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
  end

  def get(path)
    @connection.get do |req|
      req.headers['X-Auth-Token'] = @token

      req.url "/#{path}"
    end
  end
end
