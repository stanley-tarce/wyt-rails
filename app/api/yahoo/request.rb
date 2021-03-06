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
      parsed_e = JSON.parse(e.response)
      { code: e.http_code, status: e.message, data: parsed_e['error']['description'] }
    rescue JSON::ParserError
      { code: 400, status: 'Bad Request', data: 'API Error' }
    end
  
  end
end
