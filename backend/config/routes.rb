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

    resources :workspaces, only: [:index, :create, :show, :update, :destroy] do
      member do
        get :users
        get :invitation_code
      end

      resources :tasks, only: [:index, :create]
    end

    resources :tasks, only: [:show, :destroy, :update] do
    end

    post 'user_workspaces/join', to: 'user_workspaces#join'
    delete 'user_workspaces/:id/leave', to: 'user_workspaces#leave'
  end
end