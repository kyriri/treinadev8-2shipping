Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "home#index"

  resources :shipping_companies, only: [:index, :show, :new, :create, :edit, :update]
end
