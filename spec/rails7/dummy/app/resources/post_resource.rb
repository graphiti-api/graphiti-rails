class PostResource < ApplicationResource
  attribute :title, :string
  attribute :upvotes, :integer
  attribute :active, :boolean

  # For testing context
  attribute :controller, :string do
    context.class.name
  end

  attribute :action, :string do
    context.action_name
  end
end
