Rails.application.config.middleware.use OmniAuth::Builder do
    provider :yahoo_auth, 
    ENV['YAHOO_CLIENT_ID_STAN'], 
    ENV['YAHOO_CLIENT_SECRET_STAN']
    redirect_uri: 'https://d0b3-152-32-104-193.ngrok.io/auth/yahoo_auth/callback'
  end 
OmniAuth.config.allowed_request_methods = %i[get post]