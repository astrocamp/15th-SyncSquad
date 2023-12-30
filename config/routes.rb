Rails.application.routes.draw do
  root 'main#home'
  get '/about', to: 'main#about'
  get '/privacy', to: 'main#privacy'
  get '/feature/calendar', to: 'main#calendar'
  get '/feature/chatroom', to: 'main#chatroom'
  get '/feature/project', to: 'main#project'

  devise_for :users, controllers: {
  sesions: 'users/sessions',
  registrations: 'users/registrations'
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

  # company session
  resource :sessions, only: [:create, :destroy]
  resources :hrs, only: [:index, :create, :update, :destroy]

end
