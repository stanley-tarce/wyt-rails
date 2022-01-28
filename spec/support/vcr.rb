VCR.configure do |config|
    config.cassette_library_dir = "spec/cassettes"
    config.hook_into :webmock
    config.configure_rspec_metadata!
    config.cassette_serializers[:better_binary] = VcrBetterBinary::Serializer.new
    config.default_cassette_options = {
        :match_requests_on => [:uri, :method, :body],
        :record => :new_episodes,
        :serialize_with => :better_binary
    }
end