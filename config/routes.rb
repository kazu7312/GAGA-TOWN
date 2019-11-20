Rails.application.routes.draw do
  root "static_pages#home"
  post '/', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  get '/signup', to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :users

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :books, only: [:edit, :update, :create, :destroy]

  get '/search', to: 'search#new'
  post '/search', to: 'search#create'

  resources :products
end
