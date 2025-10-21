Rails.application.routes.draw do
  root "users#index"
  # Global errors
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  resources :users, only: [ :new, :create, :show ]
  get "signup", to: "users#new", as: "signup"
  get "profile", to: "users#profile", as: "profile"
  patch "profile", to: "users#update_profile", as: "update"
  get "settings", to: "users#settings", as: "settings"
  patch "settings", to: "users#update_password", as: "update_password"
  delete "settings", to: "users#delete_account", as: "delete_account"

  resources :sessions, only: [ :new, :create, :destroy ]
  get "login", to: "sessions#new", as: "login"
  delete "logout", to: "sessions#destroy", as: "logout"
end
