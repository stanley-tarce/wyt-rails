Rails.application.config.middleware.use OmniAuth::Builder do
    provider :yahoo_auth, 
    ENV['WYT_RAILS_CONSUMER_KEY'],
    ENV['WYT_RAILS_CONSUMER_SECRET']
  end
OmniAuth.config.allowed_request_methods = %i[get post]