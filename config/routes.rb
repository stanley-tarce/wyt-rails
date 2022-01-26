Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'auth/yahoo_auth/callback', to: 'sessions#callback'
  delete 'auth/yahoo_auth/logout', to: 'sessions#delete' #Logout #! NEED: Auth Token in Headers
  get 'user', to: 'users#show'
  namespace :api do 
    get '/leagues', to: 'leagues#index' #First Page
    get '/roster_with_stats', to: 'teams#roster_with_stats' #Compare Team Roster with Stats (For Create Trade)
    get '/teams', to: 'teams#teams' #Get all Teams in specific League #! NEED: League Key in query params
    get '/stats', to: 'teams#stats'
    get '/trades', to: 'trades#index' #Trades Index #! NEED: League Key in query params
    post '/create_trade', to: 'trades#create' #Create Trade #! NEED: team_name, team_key, players_to_send(Array with  keys player_name, player_key), players_to_receive(Array with keys player_name, player_key), league_key in query params
    get '/trades/:trade_id', to: 'trades#show' #Show Specific Trade #! NEED: trade_id in url params 
    get '/trades/:trade_id/owner', to: 'trades#owner' #Show Specific Trade #! NEED: trade_id in url params 
    patch '/trades/:trade_id', to: 'trades#update' #Update Specific Trade #! NEED: trade_id in url params
    delete '/trades/:trade_id', to: 'trades#delete' #Delete Specific Trade #! NEED: trade_id in url params
    get '/trades/:trade_id/comments', to: 'comments#index' #Comments #! NEED: ALL trade_id in url params
    get '/trades/:trade_id/comments/:comment_id', to: 'comments#show'
    post '/trades/:trade_id/comments', to: 'comments#create'
    patch '/trades/:trade_id/comments/:comment_id', to: 'comments#update'
    delete '/trades/:trade_id/comments/:comment_id', to: 'comments#destroy'
  end
end
