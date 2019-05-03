require 'rails_helper'

RSpec.describe "posts#destroy", type: :request do
  subject(:make_request) do
    jsonapi_delete "/api/v1/posts/#{post.id}"
  end

  describe 'basic destroy' do
    let!(:post) { create(:post) }

    it 'updates the resource' do
      expect(PostResource).to receive(:find).and_call_original
      expect {
        make_request
        expect(response.status).to eq(200), response.body
      }.to change { Post.count }.by(-1)
      expect { post.reload }
        .to raise_error(ActiveRecord::RecordNotFound)
      expect(json).to eq('meta' => {})
    end
  end
end
