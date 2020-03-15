Rails.application.routes.draw do
  get '/', to:'products#lists', as: :lists
  get '/users/profiles', to:'users#profiles', as: :top
  get '/users/sign_up', to:'users#sign_up', as: :sign_up
  post '/users/sign_up', to: 'users#sign_up_process'
  get '/users/sign_in', to:'users#sign_in', as: :sign_in
  post '/users/sign_in', to: 'users#sign_in_process'
  get	'/users/sign_out',	to: 'users#sign_out',	as: :sign_out
  get '/users/products', to:'products#show'
  get '/users/likes', to:'users#likes' , as: :likes
  resources :products do
    member do
      get 'like', to: 'products#likes', as: :like
    end
  end
  get '/markets/(:id)', to: 'products#markets', as: :markets
  delete  '/posts/(:id)', to: 'products#destroy'
  get '/users/products/new', to:'products#new', as: :new
  resources :products
  post '/users/products/new', to: 'products#create', as: :create
  get '/users/profiles/edit', to: 'users#edit',as: :edit
  post '/users/profiles/edit', to: 'users#update', as: :update
  get '/markets/(:id)/payment', to: 'products#payment', as: :payment
  post '/markets/(:id)/payment', to: 'products#sold', as: :sold
  get '/users/products/(:id)', to: 'products#details', as: :details
  get '/users/products/(:id)/edit', to: 'products#product_edit', as: :product_edit
  post '/users/products/(:id)/edit', to: 'products#product_update', as: :product_update
end