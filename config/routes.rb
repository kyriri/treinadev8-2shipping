Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'home#index'

  resources :shipping_companies, only: [:index, :show, :new, :create, :edit, :update]
  post '/shipping_companies/:id', to: 'shipping_companies#fake_delete', as: 'fake_delete_shipping_company'

end
