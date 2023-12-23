Rails.application.routes.draw do
  root "main#home"

  get 'users/show'
  resources :rooms do
    resources :messages
  end
  
  
  devise_for :users, controllers: {
  registrations: 'users/registrations/registrations'
}

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
    member do
      resources :lists do
        resources :tasks
      end
    end
  end

  resources :rooms do
    resources :messages
  end

  resources :companies, except: [:destroy] do
    collection do
      get :sign_in
    end
  end

  resource :sessions, only: [:create, :destroy]

end
