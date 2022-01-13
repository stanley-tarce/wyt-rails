module CookieHelper
  require 'cgi'
  require 'active_support'
  def verify_and_decrypt(token)
    config = Rails.application.config
    cookie = CGI.unescape(token)
    salt   = config.action_dispatch.authenticated_encrypted_cookie_salt
    encrypted_cookie_cipher = config.action_dispatch.encrypted_cookie_cipher || 'aes-256-gcm'
    serializer = ActiveSupport::MessageEncryptor::NullSerializer

    key_generator = ActiveSupport::KeyGenerator.new(Rails.application.secret_key_base, iterations: 1000)
    key_len = ActiveSupport::MessageEncryptor.key_len(encrypted_cookie_cipher)

    secret = key_generator.generate_key(salt, key_len)
    encryptor = ActiveSupport::MessageEncryptor.new(secret, cipher: encrypted_cookie_cipher, serializer: serializer)

    encryptor.decrypt_and_verify(cookie)
  end

end