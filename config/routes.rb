Rails.application.routes.draw do
  devise_for :users
  resources :items
  resources :users, only: [:show]
  namespace :static do
    resources :team, :contact, :ui_kit, only: [:index]
  end
  root 'items#index'
end
