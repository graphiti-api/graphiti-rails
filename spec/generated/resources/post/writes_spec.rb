require 'rails_helper'

RSpec.describe PostResource, type: :resource do
  describe 'creating' do
    let(:payload) do
      {
        data: {
          type: 'posts',
          attributes: { }
        }
      }
    end

    let(:instance) do
      PostResource.build(payload)
    end

    it 'works' do
      expect {
        expect(instance.save).to eq(true), instance.errors.full_messages.to_sentence
      }.to change { Post.count }.by(1)
    end
  end

  describe 'updating' do
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

    let(:instance) do
      PostResource.find(payload)
    end

    it 'works (add some attributes and enable this spec)' do
      expect {
        expect(instance.update_attributes).to eq(true)
      }.to change { post.reload.updated_at }
       .and change { post.upvotes }.to(10)
    end
  end

  describe 'destroying' do
    let!(:post) { create(:post) }

    let(:instance) do
      PostResource.find(id: post.id)
    end

    it 'works' do
      expect {
        expect(instance.destroy).to eq(true)
      }.to change { Post.count }.by(-1)
    end
  end
end
