Rails.application.routes.draw do
  devise_for :users
  resources :items
  resources :users, only: [:show]
  root 'items#index'
end
