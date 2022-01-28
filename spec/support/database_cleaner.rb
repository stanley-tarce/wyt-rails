# frozen_string_literal: true

RSpec.configure do |config|
  # config.before(:example) do
  #   DatabaseCleaner.clean_with(:truncation) #Truncate before running each test
  # end
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
  # config.before(:each, js: true) do
  #   DatabaseCleaner.strategy = :truncation
  # end
  # config.before(:each) do
  #   DatabaseCleaner.start
  # end
  # config.after(:each) do
  #   DatabaseCleaner.clean
  # end
  config.after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
end
