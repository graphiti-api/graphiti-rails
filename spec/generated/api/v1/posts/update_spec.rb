require 'rails_helper'

RSpec.describe "posts#update", type: :request do
  subject(:make_request) do
    jsonapi_put "/api/v1/posts/#{post.id}", payload
  end

  describe 'basic update' do
    let!(:post) { create(:post) }

    let(:payload) do
      {
        data: {
          id: post.id.to_s,
          type: 'posts',
          attributes: {
            upvotes: 10
          }
        }
      }
    end

    it 'updates the resource' do
      expect(PostResource).to receive(:find).and_call_original
      expect {
        make_request
        expect(response.status).to eq(200), response.body
      }.to change { post.reload.attributes }
    end
  end
end
