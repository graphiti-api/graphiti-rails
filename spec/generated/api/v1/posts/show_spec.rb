require 'rails_helper'

RSpec.describe "posts#show", type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/v1/posts/#{post.id}", params: params
  end

  describe 'basic fetch' do
    let!(:post) { create(:post) }

    it 'works' do
      expect(PostResource).to receive(:find).and_call_original
      make_request
      expect(response.status).to eq(200)
      expect(d.jsonapi_type).to eq('posts')
      expect(d.id).to eq(post.id)
    end
  end
end
