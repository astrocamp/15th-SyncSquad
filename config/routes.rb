Rails.application.routes.draw do
  devise_for :users
  resources :companies
  resources :events
  # Defines the root path route ("/")
  root "main#home"
end
