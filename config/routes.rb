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

  resources :products, only: %i[index show]
  root 'home#index'

  namespace :admins do
    resources :users, only: %i[index edit update]
    resources :products, only: %i[index show new create edit update]
    root 'products#index'
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
