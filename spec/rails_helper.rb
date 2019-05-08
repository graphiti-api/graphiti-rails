ENV["RAILS_ENV"] ||= "test"

require_relative "dummy/config/environment"
require "rspec/rails"
require "rspec/mocks"
require 'graphiti_spec_helpers/rspec'
require 'factory_bot'

FactoryBot.find_definitions

module SpecHelpers
  def handle_request_exceptions
    original_value = Rails.application.config.action_dispatch.handle_exceptions

    Rails.application.config.action_dispatch.handle_exceptions = true
    # Also set this since it may have been cached
    Rails.application.env_config["action_dispatch.show_exceptions"] = true

    yield

    Rails.application.env_config["action_dispatch.show_exceptions"] = original_value
    Rails.application.config.action_dispatch.handle_exceptions = original_value
  end
end

RSpec.configure do |config|
  config.include GraphitiSpecHelpers::RSpec
  config.include GraphitiSpecHelpers::Sugar
  config.include FactoryBot::Syntax::Methods
  config.include SpecHelpers

  config.example_status_persistence_file_path = File.expand_path(".rspec-examples.txt", __dir__)

  config.mock_with :rspec

  config.use_transactional_fixtures = true
end
