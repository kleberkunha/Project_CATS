Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show] do
    resources :carts
  end
  resources :items
  root 'items#index'
end
