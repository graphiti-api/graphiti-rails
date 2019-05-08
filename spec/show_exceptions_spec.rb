require_relative "rails_helper"

RSpec.describe "showing exceptions", type: :request do
  around do |example|
    handle_request_exceptions do
      show_detailed_exceptions(false) { example.run }
    end
  end

  context "JSON API" do
    it "renders JSON API format" do
      jsonapi_get "/not_found"
      expect_jsonapi_error("ActiveRecord::RecordNotFound")
    end
  end

  context "additional registered format" do
    around do |example|
      with_registered_formats(:xml) { example.run }
    end

    it "renders via Graphiti" do
      get "/not_found", headers: { "Accept": "application/xml" }
      expect_xml_error
    end
  end

  context "unregistered format" do
    it "calls default exceptions app" do
      get "/not_found", headers: { "Accept": "application/xml" }
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(response.content_type).to eq("application/xml")
      expect(response.body).to include("<status type=\"integer\">404</status>")
    end
  end
end
