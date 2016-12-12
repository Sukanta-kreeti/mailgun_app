Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'

  root   'home#index'
  get    '/help',    to: 'home#help'
  get    '/about',   to: 'home#about'
  get    '/contact', to: 'home#contact'
  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :account_activations, only: [:edit],  param: :token, :constraints => {:token => /[^\/]+/}
  get '/webhooks',  to: 'mailgun_webhooks#csv', as: :mailgun_webhooks
end
