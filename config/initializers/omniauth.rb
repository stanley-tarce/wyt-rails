Rails.application.config.middleware.use OmniAuth::Builder do
    provider :yahoo_auth, 
    ENV['YAHOO_CLIENT_ID_STAN_V2'], 
    ENV['YAHOO_CLIENT_SECRET_STAN_V2'],
    redirect_uri: 'https://a58d-136-158-0-147.ngrok.io/auth/yahoo_auth/callback'
  end 
OmniAuth.config.allowed_request_methods = %i[get post]