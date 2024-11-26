Rails.application.routes.draw do
  get ":id", to: "qrs#details", constraints: { id: /[a-fA-F0-9]{10}/ }

  devise_for :users 
  
  resources :companies, except: [:destroy]
  resources :delegations, only: [:index] do
    member do
      get :apoderar
      post :apoderar, to: "delegations#completar_apoderamiento"
    end
  end
  
  resources :qrs, only: [:index, :show]
  resources :tipo_procedimientos, only: [:index]
  resources :reglamento_tecnicos, only: [:index]
  resources :djcs, only: [:index, :new, :edit, :update, :show] do
    member do
      get :certificados
      post :certificados, to: "djcs#save_certificados"
    end
  end
  
  namespace :api do
    namespace :v1 do
      resources :delegations, only: [] do
        collection do
          post :delegar
          post "aceptar", to: "delegations#aceptar", as: "aceptar"
          post "rechazar", to: "delegations#rechazar", as: "rechazar"
        end
      end
      resources :companies, only: [:index, :show, :destroy] do
        member do
          get :qrs
        end
      end
      resources :roles, only: [:destroy]
      resources :djcs, only: [:create] do
        member do
          put :approve 
          put :sign
        end
      end
      resources :qrs, only: [:create, :show]
      resources :tipo_procedimientos, only: [:create, :index, :destroy]
      resources :reglamento_tecnicos, only: [:create, :index, :destroy]
    end
  end
  
  # Namespace para administración de usuarios, accesible solo por administradores
  namespace :admin do
    resources :users, only: [:index, :new, :create, :edit, :update, :show] do
      member do
        get "change_password", to: "users#password"
      end
    end
  end

  # Redirigir la raíz al inicio de sesión
  authenticated :user do
    root "companies#index", as: :authenticated_root
  end

  # Configuración de raíz para usuarios no autenticados
  devise_scope :user do
    unauthenticated do
      root "devise/sessions#new", as: :unauthenticated_root
    end
  end
end