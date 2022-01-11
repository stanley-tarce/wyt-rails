module Yahoo
    class Refresh
        def self.refresh(body)
            result = RestClient::Request.execute(method: 'post', url: "https://api.login.yahoo.com/oauth2/get_token", headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }, payload: body)
            { code: result.code, status: 'Success', data: JSON.parse(result.body) }
            rescue RestClient::ExceptionWithResponse => e
            { code: e.http_code, status: e.message, data: Errors.map(e.http_code) }
        end
    end
end

        