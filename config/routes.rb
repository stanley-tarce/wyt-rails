Rails.application.routes.draw do
  resources :comments
  resources :sent_players
  resources :received_players
  resources :trades
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'auth/yahoo_auth/callback', to: 'sessions#callback'
  get '/users', to: 'users#index'
  get '/cookie', to: 'users#cookie'
  namespace :api do 
    # get '/leagues', to: 'teams#leagues'
    # get '/league', to: 'teams#league'
    # get '/players', to: 'teams#players'
    # get '/teams', to: 'teams#teams'
    get '/stats', to: 'teams#stats'
    get '/trades', to: 'trades#index'
    get '/leagues', to: 'leagues#index'

  end
end
