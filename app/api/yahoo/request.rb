# frozen_string_literal: true

module Yahoo
  class Request
    BASE_URL = 'https://fantasysports.yahooapis.com/fantasy/v2'

    def self.call(http_method, endpoint, token)
      result = RestClient::Request.execute(
        method: http_method,
        url: "#{BASE_URL}#{endpoint}",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer #{token}"
        }
      )
      { code: result.code, status: 'Success', data: JSON.parse(result.body) }
    rescue RestClient::ExceptionWithResponse => e
      { code: e.http_code, status: e.message, data: Errors.map(e.http_code) }
    end
  end
end
