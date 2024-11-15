Rails.application.routes.draw do
  resources :delegate_companies
  resources :companies, except: [:destroy] do
    member do
      get :delegate
      put :restore
    end
  end
  resources :delegacions
  resources :tipo_procedimientos
  resources :reglamento_tecnicos
  resources :qrs
  resources :declaracion_conformidads
  devise_for :users

  # Namespace para administración de usuarios, accesible solo por administradores
  namespace :admin do
    resources :users, only: [:index, :new, :create, :edit, :update]
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