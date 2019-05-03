ENV["RAILS_ENV"] ||= "test"

require_relative "dummy/config/environment"
require "rspec/rails"
require "rspec/mocks"
require 'graphiti_spec_helpers/rspec'
require 'factory_bot'

FactoryBot.find_definitions

module SpecHelpers
  def jsonapi_headers
    super.merge('HTTP_ACCEPT' => 'application/vnd.api+json')
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
