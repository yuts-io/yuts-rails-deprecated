Rails.application.routes.draw do
  get '/courses/sort_init/:season/:sorter/:direction', to: 'courses#sort_init'
  get '/courses/sort_more/:season/:sorter/:direction', to: 'courses#sort_more'
  get '/courses/search/:season', to: 'courses#search'
  get '/courses/:season/:amount/load_more', to: 'courses#load'
  get 'auth/:provider/callback', to: 'sessions#googleAuth'
  get 'auth/failure', to: redirect('/')
  get '/courses/:season/new_season_home', to: 'courses#new_season_home'
  resources :sessions
  resources :users
  resources :courses

  root 'courses#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
