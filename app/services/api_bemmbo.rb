require_relative './http_status_codes.rb'

module Services
  class ApiBemmbo
    include HttpStatusCodes
    API_ENDPOINT = 'https://recruiting.api.bemmbo.com/'.freeze

    # Main method to make get HTTP calls
    def fetch(endpoint, http_method = :get, params = {})
      begin
        request(
          http_method: http_method,
          endpoint: endpoint,
          params: params
        )
      rescue Faraday::ConnectionFailed => e
        puts "Connection failed 😢😭, please check your internet connection and try again"
      end
    end

    private

    # Method to build a Faraday HTTP Client
    def client
      @_client ||= Faraday.new(API_ENDPOINT) do |client|
        client.request :url_encoded
        client.adapter Faraday.default_adapter
      end
    end

    # Main Method to build and execute HTTP Request like :get, :post, :put, :patch
    # Params:
    # http_method Symbol
    # endpoint String
    # params Hash
    # Return parsed response Json
    def request(http_method:, endpoint:, params: {})
      parsed_body = http_method == :post ? params&.to_json : params
      response = client.public_send(http_method, endpoint, parsed_body)
      parsed_response = Oj.load(response.body)
      return parsed_response if response.status == HTTP_OK_CODE
      { code: response.status, response: response.body }
    end
  end
end