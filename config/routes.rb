Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      resources :users, only: [:index, :show, :create, :update]
      namespace :users do
        post :sign_in
        delete :sign_out
        post :sign_up
        post :confirm_mail
        post :resend_confirmation
        put :refresh_token
        put :reset_password
        get :delegations
      end
      
      resources :companies, only: [:index, :show, :destroy, :create, :update] do
        member do
          get :qrs
        end
      end

      resources :delegations, only: [:create] do
        member do
          put :accept
          put :decline
          put :accept_with_auth
        end
      end

      resources :qrs, only: [:index] do
        member do
          get :download
        end
      end

      resources :djcs, only: [:index, :show, :create, :update] do
        member do
          put :sign
          put :approve
          get :download
          put :certificados
        end
      end

    end
  end
end
