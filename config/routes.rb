Rails.application.routes.draw do
  devise_for :users,
  path: '',
  path_names: {
    sign_in: 'login',
    sign_out: 'logout'
  },
  controllers: {
    sessions: 'users/sessions'
  }


  namespace :api do
  namespace :v1 do
    
    get 'me', to: 'me#show', defaults: { format: :json }
    put 'me/avatar', to: 'me#update_avatar'

    resources :products, defaults: { format: :json } do
      resources :stocks, only: [:index, :create], defaults: { format: :json }
      resources :sales, only: [:index, :create], defaults: { format: :json }
    end
  end
end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
