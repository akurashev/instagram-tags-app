Rails.application.routes.draw do
  resources :tags, only: %i(index new create show)

  root 'tags#index'
end
