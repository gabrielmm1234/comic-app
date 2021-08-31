Rails.application.routes.draw do
  scope module: :comic do
    root to: 'comics#index'
    get 'comics', to: 'comics#index'
  end
end
