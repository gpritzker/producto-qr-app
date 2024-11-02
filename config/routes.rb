Rails.application.routes.draw do
  devise_for :users
  resources :products, only: [:index, :new, :create, :show, :edit, :update, :destroy]

  # Redirigir la raíz al inicio de sesión
  authenticated :user do
    root "products#index", as: :authenticated_root
  end

  unauthenticated do
    root "devise/sessions#new", as: :unauthenticated_root
  end
end
