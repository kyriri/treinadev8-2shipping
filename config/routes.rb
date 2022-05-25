Rails.application.routes.draw do
  # manages authentication routes with gem Devise
  devise_for :users

  authenticate :user do
    # defines the root path route ("/")
    root 'home#index'

    resources :shipping_companies, only: [:index, :show, :new, :create, :edit, :update] do
      resources :shipping_rates, only: [:index]
    end
    # the route below goes unnested so that "fake_delete" doesn't appear on URL
    post '/shipping_companies/:id', to: 'shipping_companies#fake_delete', as: 'fake_delete_shipping_company'

    resources :service_orders, only: [:index, :show]
  end
end
