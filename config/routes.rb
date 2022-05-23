Rails.application.routes.draw do
  # manages authentication routes with gem Devise
  devise_for :users

  # defines the root path route ("/")
  root 'home#index'

  resources :shipping_companies, only: [:index, :show, :new, :create, :edit, :update] do
    resources :shipping_fees, only: [:index]
  end
  # the route below goes unnested so that "fake_delete" doesn't appear on URL
  post '/shipping_companies/:id', to: 'shipping_companies#fake_delete', as: 'fake_delete_shipping_company'

end
