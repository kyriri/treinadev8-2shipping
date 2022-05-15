Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "home#index"

  resources :shipping_company, only: [:index, :show]
end
