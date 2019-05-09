ENV["RAILS_ENV"] ||= "test"

require_relative "dummy/config/environment"
require "rspec/rails"
require "rspec/mocks"
require 'graphiti_spec_helpers/rspec'
require 'factory_bot'

FactoryBot.find_definitions

module SpecHelpers
  def handle_request_exceptions(handle = true)
    original_value = Rails.application.config.action_dispatch.handle_exceptions

    Rails.application.config.action_dispatch.handle_exceptions = handle
    # Also set this since it may have been cached
    Rails.application.env_config["action_dispatch.show_exceptions"] = handle

    yield

    Rails.application.env_config["action_dispatch.show_exceptions"] = original_value
    Rails.application.config.action_dispatch.handle_exceptions = original_value
  end

  def show_detailed_exceptions(show = true)
    original_value = Rails.application.config.action_dispatch.show_detailed_exceptions

    Rails.application.config.action_dispatch.show_detailed_exceptions = show
    # Also set this since it may have been cached
    Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = show

    yield

    Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = original_value
    Rails.application.config.action_dispatch.show_detailed_exceptions = original_value
  end

  def expect_jsonapi_error(error_name, detailed: false)
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(response.content_type).to eq("application/vnd.api+json")

    meta =
      if detailed
        hash_including(
          "__details__" => a_hash_including(
            "exception" => a_string_including(error_name)
          )
        )
      else
        { }
      end

    json = JSON.parse(response.body)
    expect(json["errors"]).to match([
      a_hash_including(
        "code" => "not_found",
        "status" => "404",
        "title" => "Not Found",
        "meta" => meta
      )
    ])
  end

  def expect_xml_error(detailed: false)
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(response.content_type).to eq("application/xml")

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
    expect(response.content_type).to eq("text/html")

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
  config.include SpecHelpers

  config.example_status_persistence_file_path = File.expand_path(".rspec-examples.txt", __dir__)

  config.mock_with :rspec

  config.use_transactional_fixtures = true
end
