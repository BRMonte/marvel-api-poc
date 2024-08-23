Rails.application.routes.draw do
  root 'pages#home'

  # get 'comics', to: 'comics#index'
  # patch 'comics/:id', to: 'comics#favorite', as: :favorite_comics
  resources :comics, only: [:index] do
    member do
      patch 'favorite'
    end
  end

  resources :characters do
    collection do
      get 'search'
    end
  end
end
