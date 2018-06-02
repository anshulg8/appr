Rails.application.routes.draw do
  devise_for :users do
    member do
      get :following, :followers
    end
  end
  get 'users/:id' => 'users#show'
  get 'users' => 'users#index'
  get 'buzzwords' => 'buzzwords#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :microposts
  root 'microposts#index'
  resources :relationships, only: [:create, :destroy]
end
