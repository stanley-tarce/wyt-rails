Rails.application.routes.draw do
  resources :comments
  resources :sent_players
  resources :received_players
  resources :trades
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'auth/yahoo_auth/callback', to: 'sessions#callback'
  namespace :api do 
    # get '/leagues', to: 'teams#leagues'
    # get '/league', to: 'teams#league'
    # get '/players', to: 'teams#players'
    get '/teams', to: 'teams#teams'
    get '/stats', to: 'teams#stats'
    get '/trades', to: 'trades#index'
    get '/trades/:trade_id', to: 'trades#show' 
    get '/trades/:trade_id/comments', to: 'comments#index'
    get '/trades/:trade_id/comments/:comment_id', to: 'comments#show'
    post '/trades/:trade_id/comments', to: 'comments#create'
    patch '/trades/:trade_id/comments/:comment_id', to: 'comments#update'
    delete '/trades/:trade_id/comments/:comment_id', to: 'comments#destroy'
    get '/leagues', to: 'leagues#index'
    get '/roster_with_stats', to: 'teams#roster_with_stats'
    post '/create_trade', to: 'trades#create'
  end
end
