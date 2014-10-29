ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'simplecov'
SimpleCov.start
require 'capybara/rails'
require_relative 'support/test_password_helper'


Capybara.server_port = 31337
Capybara.current_driver = :selenium


class ActiveSupport::TestCase
  include TestPasswordHelper

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  self.use_transactional_fixtures = false

  def logged_in_session
    { current_user_id: users(:one).id }
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
end

ActiveRecord::FixtureSet.context_class.send :include, TestPasswordHelper
