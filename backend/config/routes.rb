Rails.application.routes.draw do
  namespace :api do
    namespace :user do
      post 'signup', to: 'auth#signup'
      post 'login', to: 'auth#login'
      patch 'update_name', to: 'auth#update_name'
      patch 'update_password', to: 'auth#update_password'
      delete 'logout', to: 'auth#logout'
      get 'me', to: 'auth#me'
    end
  end
end
