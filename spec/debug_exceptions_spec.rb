require_relative "rails_helper"

RSpec.describe "debugging exceptions", type: :request do
  around do |example|
    handle_request_exceptions { example.run }
  end

  # `config.debug_exception_response_format = :api` is set in `spec/dummy/config/application.rb`
  context "debug_exception_response_format = :api" do
    context "standard graphiti error" do
      it "renders details" do
        jsonapi_get "/graphiti_not_found"
        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        expect(response.content_type).to eq("application/vnd.api+json")

        json = JSON.parse(response.body)
        expect(json["errors"]).to match([
          hash_including(
            "code" => "not_found",
            "status" => "404",
            "title" => "Not Found",
            "meta" => hash_including(
              "__raw_error__" => hash_including(
                "message" => "Graphiti::Errors::RecordNotFound"
              )
            )
          )
        ])
      end
    end

    context "invalid request error" do
      it "renders details"
    end

    context "non-graphiti error" do
      context "JSON API" do
        it "renders details" do
          jsonapi_get "/not_found"
          expect(response).to_not be_successful
          expect(response.status).to eq(404)
          expect(response.content_type).to eq("application/vnd.api+json")

          json = JSON.parse(response.body)
          expect(json["errors"]).to match([
            hash_including(
              "code" => "not_found",
              "status" => "404",
              "title" => "Not Found",
              "meta" => hash_including(
                "__raw_error__" => hash_including(
                  "message" => "ActiveRecord::RecordNotFound"
                )
              )
            )
          ])
        end
      end

      context "other format" do
        it "renders default" do
          get "/not_found", headers: { "Accept": "application/json" }
          expect(response).to_not be_successful
          expect(response.status).to eq(404)
          expect(response.content_type).to eq("application/json")

          json = JSON.parse(response.body)
          expect(json).to match(hash_including(
            "status" => 404,
            "error" => "Not Found",
            "traces" => an_instance_of(Hash)
          ))
        end
      end
    end
  end

  context "debug_exception_response_format = :default" do
    before do
      # Simulate `config.debug_exception_response_format = :default`
      allow_any_instance_of(ActionDispatch::DebugExceptions).to receive(:api_request?).and_return(false)
    end

    it "renders standard HTML page" do
      jsonapi_get "/not_found"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(response.content_type).to eq("text/html")
    end
  end
end
