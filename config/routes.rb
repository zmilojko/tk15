Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do 
    get '/login', to: 'devise/sessions#new'
    get '/logout', to: 'devise/sessions#destroy'
  end

  scope '/admin' do
    resources :competitions, as: 'competitions'
    resources :cms, as: 'cms_block', controller: 'cms_blocks'
    resources :users, as: 'users' do
      get 'receipt', on: :member
    end
  end

  get 'cms/:id', to: 'cms_blocks#show'
  post '/apply', to: 'home#apply'

  root to: 'home#index'
end
