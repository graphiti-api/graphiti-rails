class PostResource < ApplicationResource
  attribute :title, :string
  attribute :upvotes, :integer
  attribute :active, :boolean
end
