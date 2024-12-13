Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :users do
        post :sign_in
        delete :sign_out
        post :sign_up
        post :confirm_mail
        post :resend_confirmation
        put :refresh_token
        put :reset_password
      end

      resources :users, only: [:index, :show, :create, :update]
        
      resources :companies, only: [:index, :show, :destroy, :create, :update] do
        member do
          get :qrs
        end
      end
    end
  end
end
