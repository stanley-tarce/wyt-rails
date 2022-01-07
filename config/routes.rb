Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'auth/yahoo_auth/callback', to: 'sessions#callback'
end
