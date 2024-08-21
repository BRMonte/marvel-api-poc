Rails.application.routes.draw do
  patch 'comics/:id', to: 'comics#favorite', as: :favorite_comics

  root to: "comics#index"
  # get 'comics/characters/:name', to: 'comics#characters', as: 'characters'
  get 'comics/characters', to: 'comics#characters', as: 'characters'
end
