Rails.application.routes.draw do
  root to: "comics#index"
  patch 'comics/:id', to: 'comics#favorite', as: :favorite_comics
  get 'comics/characters', to: 'comics#characters', as: 'characters'
end
