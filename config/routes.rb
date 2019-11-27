Rails.application.routes.draw do
  root "static_pages#home"
  post '/', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  get '/signup', to: 'users#new'
  post '/signup',  to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '/search', to: 'search#new'
  post '/search', to: 'search#create'

  get 'carts/:id', to: 'carts#show', as: 'cart'
  delete 'carts/:id', to: 'carts#destroy'

  post 'items/:id/add', to: 'items#add_quantity', as: 'item_add'
  post 'items/:id/reduce', to: 'items#reduce_quantity', as: 'item_reduce'
  post 'items/:id', to: 'items#create'
  get 'items/:id', to: 'items#show', as: 'item'
  delete 'items/:id', to: 'items#destroy'

  resources :users
  resources :products
  resources :purchases
end
