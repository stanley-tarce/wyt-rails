VCR.configure do |config|
    config.cassette_library_dir = "spec/cassettes"
    config.hook_into :webmock
    config.configure_rspec_metadata!
    config.default_cassette_options = {
        :match_requests_on => [:uri, :method, :body],
        :record => :new_episodes,
    }
end