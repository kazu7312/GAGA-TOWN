Rails.application.routes.draw do
  get 'purchases/index'

  get 'purchases/show'

  get 'purchases/new'

  get 'purchases/create'

  get 'items/create'

  get 'items/add_quantity'

  get 'items/reduce_quantity'

  get 'items/destroy'

  get 'carts/show'

  get 'carts/create'

  get 'carts/edit'

  get 'carts/update'

  get 'carts/destroy'

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

  get '/search', to: 'search#new'
  post '/search', to: 'search#create'

  resources :products
end
