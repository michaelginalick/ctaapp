Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'session#index'

  # Example of regular route:
  get '/session/notice' => 'session#notice'
      #sessions routes
  get '/session/index' => 'session#index'
  get 'session/first' => 'session#first'
  post '/session/login' => 'session#login'
  
  get '/session/logout' => 'session#logout', :as => 'logout'

  post '/user/confirm' => 'user#confirm', :as => 'confirm'
  post '/user/code' => 'user#code', :as => 'code'

  post '/user/profile' => 'user#profile', :as => 'profile'
  get 'user/profile' => 'user#profile', :as => 'userprofile'
  post 'user/delete' => 'user#delete', :as => 'delete'



  resources :user do 
    resources :train
  end
    post '/user/:id/train' => 'train#create', :as => 'create'
    get '/user/:id/stop' => 'user#stop', :as => 'stop'



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
