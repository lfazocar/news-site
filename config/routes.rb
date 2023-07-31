Rails.application.routes.draw do
  resources :articles do
    post 'comment', on: :member
  end

  devise_for :users

  root "articles#index"
end
