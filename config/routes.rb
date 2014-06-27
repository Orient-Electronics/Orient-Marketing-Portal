Orient::Application.routes.draw do





  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :user_types

  resources :home

  match '/home_activities' => "home#activities", :method => :get
  match '/subscriber_activities' => "home#subscriber_activities", :method => :get
  match '/notifications' => "home#notifications", :method => :get
  match '/user_activities' => "home#user_activities", :method => :get



  resources :roles

  resources :search

  resources :areas do
    collection do
      get "search"
    end
  end

  resources :announcements do
    collection do
      get 'update_user_status'
    end
  end

  resources :product_categories do
    resources :svrs
  end

  resources :activities do
    member do
      get 'destroy_subscriber'
    end
    collection do
      get 'update_activity'
      post 'create_subscriber'
    end
  end


  resources :dealers do
    resources :shops
    member do
      get 'gallery'
      get 'showmodal'
      get 'get_info'
    end
    collection do
      get 'showgallery'
      get 'area_field'
      get 'load_more_peoples'
    end

  end

  resources :brands do
    resources :svrs
  end


  resources :products do
    resources :svrs
  end


  resources :shop_categories do
    resources :shops
  end

  resources :cities do
    resources :shops
  end

  resources :locations do
    resources :shops
  end

  resources :shops do
    resources :uploads
    resources :svrs
    member do
      get 'delete'
    end
    collection do
      get 'area_field'
      get 'people_field'
      get 'load_more_peoples'
      get 'load_more_brand_corner_report_lines'
      get 'load_more_category_corner_report_lines'
      get 'load_more_uploads'
      get 'load_more_peoples'
      get 'load_more_shops'
    end
  end

  resources :uploads

  resources :tasks do
    member do
      post 'change_status'
    end
    collection do
      get 'publish_report'
      get 'unpublish_report'
      get 'draft_report'
      get 'submit_report'
    end
  end

  resources :svrs do
    collection do
      post 'brand_search'
      post 'category_search'
      get  'file_field'
      get 'upload_field'
    end
  end

  match 'shops/:shop_id/svr/:id' => 'svrs#show', as: 'show'

  devise_for :users, :controllers => {:registrations => "registrations"}

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
