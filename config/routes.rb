Cits3403::Application.routes.draw do
  devise_for :users
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'main#index'
  
  # routing for the album/image hierarchy
  resources :albums do
	resources :images, :shallow => true
  end  

  resources :users, :except => [:show, :create, :index, :new, :edit, :update, :destroy]  do
    member do
      get 'albums'
    end
  end
  
  # Define some root actions which route to the main controller
  scope :module => 'main' do
    get 'gallery'
    get 'people'
    get 'search'
    get 'welcome'
    get 'setup'
  end

  namespace 'friends' do
    post 'accept/:id', :action => 'accept', :as => 'accept'
    post 'request/:id', :action => 'req', :as => 'request'
    post 'remove/:id', :action => 'remove', :as => 'remove'
  end  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
