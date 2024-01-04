Rails.application.routes.draw do
  scope "(:lang)", lang: /en|tw/ do
    root 'main#home'
    get '/about', to: 'main#about'
    get '/privacy', to: 'main#privacy'
    get '/feature/calendar', to: 'main#calendar'
    get '/feature/chatroom', to: 'main#chatroom'
    get '/feature/project', to: 'main#project'
  
    devise_for :users, controllers: {
      sessions: 'users/registrations/sessions',
      registrations: 'users/registrations/registrations'
    }

    devise_scope :user do
      get 'users', to: 'devise/sessions#new'
      get 'users/import', to: 'users#index'
      post 'users/import', to: 'users#import'
    end

    get 'user/:id', to:'users#show',as: 'user'
  
    get 'users/show'
    
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
  

end
