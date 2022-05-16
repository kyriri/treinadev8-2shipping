Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'home#index'

  resources :shipping_companies, only: [:index, :show, :new, :create, :edit, :update]
  
  # the route below goes unnested so that "fake_delete" doesn't appear on URL
  post '/shipping_companies/:id', to: 'shipping_companies#fake_delete', as: 'fake_delete_shipping_company'

end
