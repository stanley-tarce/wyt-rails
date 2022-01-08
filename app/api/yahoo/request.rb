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
            {code: result.code, status: 'Success', data: JSON.parse(result.body)}
        rescue RestClient::ExceptionWith Response => error 
            { code: error.http_code, status: error.message, data: Errors.map(error.http_code)}
        end
    end
end
