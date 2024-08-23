Rails.application.routes.draw do
  root 'pages#home'

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
