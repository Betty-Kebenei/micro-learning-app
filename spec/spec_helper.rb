ENV["CURRENT_ENV"] ||= "test"

require 'coveralls'
Coveralls.wear!

require_relative '../app/controllers/application_controller'
require 'rspec'
require 'capybara/dsl'
require 'database_cleaner'

Capybara.app = ApplicationController

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.include Capybara::DSL

  config.before(:suite) do
    DatabaseCleaner.clean
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end



