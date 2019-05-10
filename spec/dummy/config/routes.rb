Rails.application.routes.draw do
  scope "/api/v1" do
    resources :posts
  end

  get "/not_found" => "static#not_found"
  get "/graphiti_not_found" => "static#graphiti_not_found"
  get "/fatal" => "static#fatal"
end
