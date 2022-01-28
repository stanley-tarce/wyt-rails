# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
OmniAuth.configure do |config|
  config.test_mode = true
  config.mock_auth[:yahoo_auth] = OmniAuth::AuthHash.new({
  provider: 'yahoo_auth',
  info: {
    nickname: 'Test',
    email: 'test@yahoo.com',
    first_name: 'Stanley',
    last_name: 'Test Spectre',
    image: 'https://s.yimg.com/wm/modern/images/default_user_profile_pic_192.png',
  },
  credentials: {
    token: 'wxr7h0CbuBsJhS_xd8igMeFocidQ3TZMyxKh86PNSR1CX9IZnvMLeYllNLB5.HKDt_Xwszf4FfQtwCrqdELXBhL1.kQMz_VWF6yKYm_c86Ip_7WCxbiU5PZlIF7tvn9zbLGPhQ3IJoxhTIIL_EU9TAGVQQjEAZEK7reMCQuiJN4zAQXbT94Ne1wnO.oJVOryzNmupET.M7jbNXEV3TBbfF0TA93uQ7hxRiF4JFPMZu_N97q3QAUzLppXN.6k2NgO8EVkkoFkfvm5FbHbUBcVgUfSF6zF1xm1yEN2b4EdN00Jvx6xJsCJ8OkusNO36.2oQ27eCeBoZ8we0eNGHcNG243CPgRnmzB018wVcEir_5BWbTW9W_nRIfjn.V04MB_A2swUYEwN6vVy92isj0IFik.rNpk2RGywOWPPW44HgiWoR2EQDovmR47.ifSID6.0bqq1z7uzjBWtvlMM8zIdWIF7MC2zwT3mhj7qgiDqYiLsh9UhaTmSbfgSRk4rnrsuZlQDtjzTi3d3uuQEFkOe7mdiw9HBl58by3i3a_wcpyuLnjaOJ8o7aySgIwGRjwbzpu02VAE0x3FLjreSRDEqQ9F6qr0vH8mpCBmlLfMgwXR2VNuz_nuTDdN4AEx4ghYGMQOaI4TX0zG5KCNPXkhOl2ufTZkhr4lh9Rv6p0BHKzSnchebOlI7T7gvc0XeF74pLAiUquUF1mnjdpycSGApALrk0Z8cYZCMtim.mNvbi3IuwhFUUn5puAP2fUIFlMtxz6Bc2LA9.1HWAu9HAU6.SQ0q0W4xbIvH0wGmbrVFj2SKIw.4Pb5ghRLAIir9nTpHEQXabS6ocE1YnSoc5dZBXptcdiDV45W868sZgjB.ANBUxP_lGm622z.nqBNnQ2Xo8SYW9kE_tp6vUCE4GrERSd3n9.9gJqDyudzluUc1w25mHlVOMnCRUZ8KXkmoDWACsBlLUEPHCT3ouv8yGUgH6TH61stNasnslUi.JFNLfw3JRw_zborGunEx_ABEL8cFuNgS6fmO8egkS_ixsarRTO32Qy7GytuRIl32bf0-',
    refresh_token: "AIli2mG5W3C.4FZdv77yDkxML2DaEgcSe7s6HlPgj7bbxLap4YNrk5TQ.rn2G.DB", 
    expires_at: (Time.now.to_i + 3600).to_s, 
    expires: true 
  },
  extra: {
    sub: '',
    name: '',
    middle_name: '',
    nickname: '',
    gender: 'M',
    language: 'en-IN',
    website: '',
    birth_date: '',
    zone_info: '',
    updated_at: '',
    email_verified: true,
    address: '',
    phone_number: '',
    phone_number_verified: false,
  }
}
  )
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
