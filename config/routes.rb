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


  resources :events do 
    member do
      patch :drop
    end
  end

  resources :projects, shallow: true do
    resources :lists do
      put :sort
      resources :tasks do
        put :sort
      end
    end
    collection do
      post :aside_listed
      post :main_listed
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
  resources :hrs, only: [:index, :create, :update, :destroy]

end
