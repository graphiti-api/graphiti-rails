require_relative "rails_helper"

RSpec.describe "debugging exceptions", type: :request do
  around do |example|
    handle_request_exceptions do
      show_detailed_exceptions(true) { example.run }
    end
  end

  # `config.debug_exception_response_format = :api` is set in `spec/dummy/config/application.rb`
  context "debug_exception_response_format = :api" do
    context "JSON:API" do
      it "renders details for graphiti errors" do
        jsonapi_get "/graphiti_not_found"
        expect_jsonapi_error("Graphiti::Errors::RecordNotFound", detailed: true)
      end

      it "renders details for an invalid request error" do
        pending "This will be in the next Graphiti release"
        fail
      end

      it "renders details for a non-graphiti error" do
        jsonapi_get "/not_found"
        expect_jsonapi_error("ActiveRecord::RecordNotFound", detailed: true)
      end
    end

    context "additional registered format" do
      around do |example|
        with_registered_formats(:xml) { example.run }
      end

      it "renders with more details" do
        get "/not_found", headers: { "Accept": "application/xml" }
        expect_xml_error(detailed: true)
      end
    end

    context "unregistered format" do
      def expect_default_error
        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        expect(response.content_type).to eq("application/xml")

        expect(response.body).to include("<status type=\"integer\">404</status>")
        expect(response.body).to include("<Application-Trace type=\"array\">")
      end

      it "renders default for graphiti errors" do
        get "/graphiti_not_found", headers: { "Accept": "application/xml" }
        expect_default_error
      end

      it "renders default for non-graphiti errors" do
        get "/not_found", headers: { "Accept": "application/xml" }
        expect_default_error
      end
    end
  end

  context "debug_exception_response_format = :default" do
    before do
      # Simulate `config.debug_exception_response_format = :default`
      allow_any_instance_of(ActionDispatch::DebugExceptions).to receive(:api_request?).and_return(false)
    end

    it "renders standard HTML page for graphiti error" do
      jsonapi_get "/graphiti_not_found"
      expect_html_error(detailed: true)
    end

    it "renders standard HTML page for non-graphiti error" do
      jsonapi_get "/not_found"
      expect_html_error(detailed: true)
    end
  end
end
