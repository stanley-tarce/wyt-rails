Rails.application.routes.draw do
  resources :comments
  resources :sent_players
  resources :received_players
  resources :trades
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'auth/yahoo_auth/callback', to: 'sessions#callback'

  namespace :api do 
    get '/teams', to: 'teams#index'
    get '/leagues', to: 'teams#leagues'
    get '/league', to: 'teams#league'
  end
end
