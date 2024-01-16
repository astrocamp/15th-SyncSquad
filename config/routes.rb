Rails.application.routes.draw do
  resources :orders, only: [:index, :create]

  scope "(:lang)", lang: /en|tw/ do
    root 'main#home'
    get '/about', to: 'main#about'
    get '/privacy', to: 'main#privacy'
    get '/feature/calendar', to: 'main#calendar'
    get '/feature/chatroom', to: 'main#chatroom'
    get '/feature/project', to: 'main#project'
  

    devise_for :users, path: 'auth', only: %i[sessions registrations password]

    devise_scope :user do
      get 'users', to: 'devise/sessions#new'
      get 'users/import', to: 'users#index'
      post 'users/import', to: 'users#import'
      get 'users/import/records', to: 'users#records'
    end

    get 'user/:id', to:'users#show',as: 'user'
  
    resources :events do 
      member do
        patch :drop
      end
    end
    
    resources :projects, shallow: true do
      resources :lists, except: :index do
        put :sort
        resources :tasks, except: :index do
          put :sort
          member do
            patch :update_location
            patch :drop
          end
          resources :comments, only: [:create, :destroy]
        end
      end
      collection do
        post :aside_listed
        post :main_listed
      end
      member do
        get :kanban
        get :calendar
        get :new_task
        post :create_task
      end
    end
  
    resources :rooms, only: %i[index create show new] do
      resources :messages, only: %i[create]
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
