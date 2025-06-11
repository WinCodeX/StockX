Rails.application.routes.draw do

devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout' }, controllers: { sessions: 'users/sessions' }

namespace :api do 
namespace :v1 do

# User routes
  get 'me', to: 'me#show', defaults: { format: :json }
  put 'me/avatar', to: 'me#update_avatar'
  get 'ping', to: 'status#ping', defaults: { format: :json }
get 'users/search', to: 'users#search'
#conversation and messages

resources :conversations, only: [:index, :create, :show] do
  resources :messages, only: [:index, :create]
end

  # Product + related data
  resources :products, defaults: { format: :json } do
    collection do
      get :stats
    end

    member do
      get :history  # ✅ Fetch product stock history
    end

    resources :stocks, only: [:index, :create], defaults: { format: :json }
    resources :sales, only: [:index, :create], defaults: { format: :json }
  end

  # Sales
  resources :sales, only: [], defaults: { format: :json } do
    collection do
      get :recent
    end
  end

  # Business invites
  resources :invites, only: [:create], defaults: { format: :json } do
    collection do
      post :accept
    end
  end

  # Businesses
  resources :businesses, only: [:create, :index, :show], defaults: { format: :json }

end

end

#Health check

get "up" => "rails/health#show", as: :rails_health_check

root "posts#index" # Uncomment and customize if you want a root path

end

