require 'rails_helper'

RSpec.describe "posts#index", type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/v1/posts", params: params
  end

  describe 'basic fetch' do
    let!(:post1) { create(:post) }
    let!(:post2) { create(:post) }

    it 'works' do
      expect(PostResource).to receive(:all).and_call_original
      make_request
      expect(response.status).to eq(200), response.body
      expect(d.map(&:jsonapi_type).uniq).to match_array(['posts'])
      expect(d.map(&:id)).to match_array([post1.id, post2.id])
    end
  end
end
