module Yahoo
    class Client
        def self.teams(access_token)
            response = Request.call('get', '/team/', access_token)
        end
    end
end