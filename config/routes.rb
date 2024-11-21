Rails.application.routes.draw do
  devise_for :users
  resources :companies, except: [:destroy]
  resources :delegations, only: [:index] do
    member do
      get :apoderar
      post :apoderar, to: "delegations#completar_apoderamiento"
    end
  end
  get "d/:id", to: "qrs#details"
  resources :qrs, except: [:destroy]
  resources :tipo_procedimientos, except: [:destroy]
  resources :reglamento_tecnicos, except: [:destroy]
  resources :djcs, only: [:index, :edit, :update, :show, :new]
  
  namespace :api do
    namespace :v1 do
      resources :delegations, only: [] do
        collection do
          post :delegar
          post "aceptar", to: "delegations#aceptar", as: "aceptar"
          post "rechazar", to: "delegations#rechazar", as: "rechazar"
        end
      end
      resources :companies, only: [:index] do
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
    end
  end
  
  # Namespace para administración de usuarios, accesible solo por administradores
  namespace :admin do
    resources :users, only: [:index, :new, :create, :edit, :update, :show]
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