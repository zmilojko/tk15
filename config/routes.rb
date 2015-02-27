Rails.application.routes.draw do
  scope '/admin' do
    resources :cms, as: 'cms_block', controller: 'cms_blocks'
  end
  get 'cms/:id', to: 'cms_blocks#show'
  
  devise_for :users
  scope '/admin' do
    resources :users, as: 'users' do
      get 'receipt', on: :member
    end
  end

  post '/apply', to: 'home#apply'
  
  devise_scope :user do 
    get '/login', to: 'devise/sessions#new'
    get '/logout', to: 'devise/sessions#destroy'
  end
  
  root to: 'home#index'
end
