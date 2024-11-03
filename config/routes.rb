Rails.application.routes.draw do
  devise_for :users

  # Rutas para productos, accesibles por todos los usuarios autenticados
  resources :products, only: [:index, :new, :create, :show, :edit, :update, :destroy]

  # Namespace para administración de usuarios, accesible solo por administradores
  namespace :admin do
    resources :users, only: [:index, :new, :create, :edit, :update]
  end

  # Redirigir la raíz al inicio de sesión
  authenticated :user do
    root "products#index", as: :authenticated_root
  end

  # Configuración de raíz para usuarios no autenticados
  devise_scope :user do
    unauthenticated do
      root "devise/sessions#new", as: :unauthenticated_root
    end
  end
end