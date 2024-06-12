Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
  }

  devise_for :administrators, controllers: {
    registrations: 'admins/devise/registrations',
    sessions: 'admins/devise/sessions',
    confirmations: 'admins/devise/confirmations',
  }

  resources :products, only: %i[index show] do
    resources :cart_items, only: %i[create update destroy]
  end
  resource :cart, only: %i[show]
  resources :purchases, only: %i[index show new create] do
    collection do
      post :confirm
    end
  end
  resource :address, only: %i[show new create edit update]
  root 'home#index'

  namespace :admins do
    resources :users, only: %i[index edit update destroy]
    resources :products, only: %i[index show new create edit update]
    root 'products#index'
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
