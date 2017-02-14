Rails.application.routes.draw do
  
  root 'static#home'
  get 'igresponse/ighome', as: :ighome
  get 'igresponse/incoming'
  get 'igresponse/selffeed'
  get 'igresponse/mainfeed'
  get 'igresponse/friendlist'
  get 'admin/dashboard'
  get 'admin/users'
  get 'admin/api'
  get 'igresponse/privatefriend'
  get 'igresponse/friendfeed/:id' => 'igresponse#friendfeed', as: :friendfeed
  get 'igresponse/instapic/:id' => 'igresponse#instapic', as: :instapic
  post 'igresponse/createpostcard'
  get 'signout' => 'static#signout'
  get 'error' => 'static#error'
  get 'home' => 'static#home'
  match '/404' => 'static#issue', via: :all
  match '/422' => 'static#issue', via: :all
  match '/500' => 'static#issue', via: :all

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
