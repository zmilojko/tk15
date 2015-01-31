Rails.application.routes.draw do
  devise_for :users
  scope '/admin' do
    resources :users, as: 'users'
  end

  post '/apply', to: 'home#apply'
  
  root to: 'home#index'
end
