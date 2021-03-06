Rails.application.routes.draw do

  resources :beers
  
  match '/redeem', to: 'beers#redeem', as: 'redeem_beer', via: [:get, :post]
  # this makes beers fairly hard to guess -- we're using randomIDs instead of DB ids
  match "/beer/:randID", to: 'beers#show', as: 'showbeer', via: [:get]
  get 'beers/create'
  match 'beers/receive/:randID', to: "beers#receive", as: 'receivebeer', via: [:get]

  get 'static/home' # overridden by root route below
  match "/about", to: "static#about", via: [:get]
  get 'static/global_beer_activity'
  
  get 'user/home'
  
  # authentication
  #get 'sessions/new'
  match "sessions/new", to: 'sessions#new', as: 'signin', via: [:get, :post]
  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post]
  match "/auth/failure", to: "sessions#failure", via: [:get, :post]
  #match "/logout", to: "sessions#destroy", :as => "logout"
  match '/signout', to: 'sessions#destroy', as: 'signout', via: [:get]

  resources :identities


  # match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  # match 'auth/failure', to: redirect('/'), via: [:get, :post]
  # match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
