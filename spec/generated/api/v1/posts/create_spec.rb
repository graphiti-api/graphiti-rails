require 'rails_helper'

RSpec.describe "posts#create", type: :request do
  subject(:make_request) do
    jsonapi_post "/api/v1/posts", payload
  end

  describe 'basic create' do
    let(:params) do
      {
        # ... your attrs here
      }
    end
    let(:payload) do
      {
        data: {
          type: 'posts',
          attributes: params
        }
      }
    end

    it 'works' do
      expect(PostResource).to receive(:build).and_call_original
      expect {
        make_request
        expect(response.status).to eq(201), response.body
      }.to change { Post.count }.by(1)
    end
  end
end
