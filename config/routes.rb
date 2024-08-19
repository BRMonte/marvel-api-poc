Rails.application.routes.draw do
  patch 'comics/:id', to: 'comics#favorite', as: :favorite_comics

  root to: "comics#index"
end
