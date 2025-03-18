ENV["RAILS_ENV"] ||= "test"

require "rails/version"
if Rails::VERSION::MAJOR < 7
  require_relative "rails5/dummy/config/environment"
else
  require_relative "rails7/dummy/config/environment"
end
require "rspec/rails"
require "rspec/mocks"
require 'graphiti_spec_helpers/rspec'
require 'factory_bot'

FactoryBot.find_definitions

module SpecHelpers
  def expect_jsonapi_error(error_name, status: 404, error: { }, detailed: false)
    expect(response).to_not be_successful
    expect(response.status).to eq(status)
    expect(response.content_type).to start_with("application/vnd.api+json")

    meta =
      if detailed
        hash_including(
          "__details__" => a_hash_including(
            "exception" => a_string_including(error_name)
          )
        )
      else
        nil
      end

    json = JSON.parse(response.body)

    expected_hash = { "code" => "not_found",
      "status" => status.to_s,
      "title" => "Not Found" }
    expected_hash["meta"] = meta if meta

    expect(json["errors"]).to match([
      a_hash_including(expected_hash.merge(error))
    ])
  end

  def expect_xml_error(detailed: false)
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(response.content_type).to start_with("application/xml")

    # If we want more complex, use nokogiri
    expect(response.body).to include("<code type=\"symbol\">not_found</code>")

    if detailed
      expect(response.body).to include("<__details__>")
    else
      expect(response.body).to_not include("<__details__>")
    end
  end

  def expect_html_error(detailed: false)
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(response.content_type).to start_with("text/html")

    # We could make this check more robust
    if detailed
      expect(response.body).to include("session dump")
    else
      expect(response.body).to_not include("session dump")
    end
  end

  def with_registered_formats(*formats)
    original_formats = Graphiti::Rails.handled_exception_formats
    Graphiti::Rails.handled_exception_formats = formats
    yield
  ensure
    Graphiti::Rails.handled_exception_formats = original_formats
  end
end

RSpec.configure do |config|
  config.include GraphitiSpecHelpers::RSpec
  config.include GraphitiSpecHelpers::Sugar
  config.include FactoryBot::Syntax::Methods
  config.include RescueRegistry::RailsTestHelpers
  config.include SpecHelpers

  config.example_status_persistence_file_path = File.expand_path(".rspec-examples.txt", __dir__)

  config.mock_with :rspec

  config.use_transactional_fixtures = true
end
