Rails.application.routes.draw do
  # ✅ Remove or comment this out if you're only using API-based auth
  # devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout' }, controllers: { sessions: 'users/sessions' }

  namespace :api do
    namespace :v1 do
      # ✅ Devise routes for API (important!)
      devise_for :users,
        path: '',
        path_names: {
          sign_in: 'login',
          sign_out: 'logout'
        },
        controllers: {
          sessions: 'api/v1/sessions'
        },
        defaults: { format: :json }

      # ✅ User-specific routes
      get 'me', to: 'me#show', defaults: { format: :json }
      put 'me/avatar', to: 'me#update_avatar'
      get 'ping', to: 'status#ping', defaults: { format: :json }
      get 'users/search', to: 'users#search'
      post 'typing_status', to: 'typing_status#create'

      # ✅ Conversations & messages
      resources :conversations, only: [:index, :create, :show] do
        resources :messages, only: [:index, :create]
      end

      # ✅ Products
      resources :products, defaults: { format: :json } do
        collection do
          get :stats
        end

        member do
          get :history
        end

        resources :stocks, only: [:index, :create], defaults: { format: :json }
        resources :sales, only: [:index, :create], defaults: { format: :json }
      end

      # ✅ Sales
      resources :sales, only: [], defaults: { format: :json } do
        collection do
          get :recent
        end
      end

      # ✅ Business Invites
      resources :invites, only: [:create], defaults: { format: :json } do
        collection do
          post :accept
        end
      end

      # ✅ Businesses
      resources :businesses, only: [:create, :index, :show], defaults: { format: :json }
    end
  end

  # ✅ Health Check
  get "up" => "rails/health#show", as: :rails_health_check

  # ✅ Optional: Root path (for non-API usage)
  root "posts#index"
end