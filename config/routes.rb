Rails.application.routes.draw do
  root "main#home"
  get 'main/home'
  
  devise_for :users 
  
  devise_scope :user do
    get 'users', to: 'devise/sessions#new'
  end
  get 'user/:id', to:'users#show',as: 'user'
  get 'main/home'

  resources :events do 
    member do
      patch :drop
    end
  end
  resources :projects do
    collection do
      post :aside_list
      post :main_list
    end
  end

  resources :rooms do
    resources :messages
  end
end
