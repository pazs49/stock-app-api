Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      get "user_info/get_user_info", to: "user_infos#get_user_info"
      post "admin/create_user", to: "users#admin_create_user"
      post "admin/approve_user/:id", to: "users#admin_approve_user"
      resources :users, only: [:index]
      ############################
      post "stocks/search", to: "stocks#search"
    end
  end
end
