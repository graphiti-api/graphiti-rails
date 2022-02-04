class PostsController < ApplicationController
  respond_to :json, :jsonapi

  def index
    posts = PostResource.all(params)
    respond_with(posts)
  end

  def show
    post = PostResource.find(params)
    respond_with(post)
  end

  def create
    post = PostResource.build(params)

    if post.save
      render jsonapi: post, status: 201
    else
      render jsonapi_errors: post
    end
  end

  def update
    post = PostResource.find(params)

    if post.update_attributes
      render jsonapi: post
    else
      render jsonapi_errors: post
    end
  end

  def destroy
    post = PostResource.find(params)

    if post.destroy
      render jsonapi: { meta: {} }, status: 200
    else
      render jsonapi_errors: post
    end
  end
end
