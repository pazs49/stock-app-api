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
      post "user_info", to: "users#create_user_info"
      #############################
      get "user_info/get_user_info", to: "user_infos#get_user_info"
      get "user_info/get_user_transactions", to: "user_infos#get_user_transactions"
      get "user_info/get_user_transactions_admin", to: "user_infos#get_user_transactions_admin"
      get "user_info/get_user_info_admin/:id", to: "user_infos#get_user_info_admin"
      patch "user_info/edit_user_info_admin/:id", to: "user_infos#edit_user_info_admin"
      post "user_info/edit_user_info", to: "user_infos#edit_user_info"
      post "user_info/user_deposit", to: "user_infos#user_deposit"
      ############################
      post "admin/create_user", to: "users#admin_create_user"
      post "admin/approve_user/:id", to: "users#admin_approve_user"
      resources :users, only: [:index]
      ############################
      post "stocks/search", to: "stocks#search"
      get "stocks", to: "stocks#index"
      post "stocks/buy/*", to: "stocks#buy"
      post "stocks/sell", to: "stocks#sell"
      post "stocks/update_stock_price", to: "stocks#update_stock_price"
      ############################
    end
  end
end
