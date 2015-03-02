Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do 
    get '/login', to: 'devise/sessions#new'
    get '/logout', to: 'devise/sessions#destroy'
  end

  scope '/admin' do
    resources :competitions, as: 'competitions' do
      post 'organize', on: :collection
      post 'numbers', on: :collection
      post 'next_state', on: :member
    end
    resources :cms, as: 'cms_block', controller: 'cms_blocks'
    resources :users, as: 'users' do
      get 'receipt', on: :member
    end
  end

  get 'competition', to: 'competitions#index'
  get 'cms/:id', to: 'cms_blocks#show'
  post '/apply', to: 'home#apply'

  root to: 'home#index'
end
