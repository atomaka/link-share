require 'rack/test'
require 'rspec'
require 'capybara/rspec'
require 'capybara/webkit'
require 'factory_girl'
require 'database_cleaner'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

ActiveRecord::Migration.maintain_test_schema!

module TestingMixin
  include Rack::Test::Methods
  include RSpec::Matchers
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods

  Capybara.app = Sinatra::Application
  Capybara.javascript_driver = :webkit
  Capybara.asset_host = 'http://localhost:3000'

  FactoryGirl.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
  FactoryGirl.find_definitions

  def app() Sinatra::Application end

  def basic_auth(username, password)
    if page.driver.respond_to?(:basic_auth)
      page.driver.basic_auth(username, password)
    elsif page.driver.respond_to?(:basic_authorize)
      page.driver.basic_authorize(username, password)
    elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
      page.driver.browser.basic_authorize(username, password)
    else
      raise "I don't know how to log in!"
    end
  end
end

Capybara::Webkit.configure do |config|
  config.allow_unknown_urls
end

RSpec.configure do |config|
  config.include TestingMixin

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
    Capybara.reset_sessions!
  end

  config.order = :random
  Kernel.srand config.seed
end
