Muvi::Application.routes.draw do



  match '/user_tweets/:twitter_name' => 'tweets#for_user'
  match 'search' => 'search#index'
  match 'contact_us' => 'home#contact_us'
  match 'fetch' => 'home#fetch'
  match 'fetch_tweets' => 'home#fetch_tweets'
  match 'user_agreement' => 'home#user_agreement'
  match '/auth/:provider/callback' => 'userregistrations#new'
  match 'autocomplete' => 'movies#autocomplete'
  match 'celebrityAutocomplete' => 'admin/celebrities#autocomplete'

  match "tweet_review_update", :to => "admin/movie_tweets#tweet_review_update", :via => "post"
  match "facebook_review_update", :to => "admin/movie_posts#facebook_review_update", :via => "post"

  root :to => "home#index"

  resources :user_messages
  resources :userregistrations
  resources :casts
  resources :celebrities
  resources :tweets
  resources :facebook_posts
  resources :critics_reviews
  resources :user_profiles
  resources :user_tokens
  resources :coming_soon_movies
  devise_for :users, :controllers => { :registrations => "registrations" }

  resources :movies do
    resources :comments
    resources :reviews
    resources :recommendations
    resources :critics_reviews
    resources :tweets
  end
  namespace :admin do
    root :to => 'movies#index'
    resources :movies do
      resources :movie_posts
      resources :movie_tweets
      resources :movie_comments
    end

    resources :celebrities do
      post :delete_celebrities, :on => :collection
    end
    resources :film_critics
    resources :users do
       post :delete_users, :on => :collection
    end
    resources :pages
    resources :settings
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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  match ":id" => "home#page"
end

