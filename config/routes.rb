Rails.application.routes.draw do
  devise_for :users

  resources :items do
    resources :photos, only: [:create]
  end

  resources :users, only: [:show] do
    resources :carts do
      resources :cart_lines
    end
    resources :orders
  end

  namespace :static do
    resources :team, :contact, :ui_kit, only: [:index]
  end

  root 'items#index'
  
  scope '/checkout' do
    post 'create', to: 'checkout#create', as: 'checkout_create'
    get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
    get 'success', to: 'checkout#success', as: 'checkout_success'
  end
end
