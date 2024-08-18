Rails.application.routes.draw do
  resources :complaints, only: [:create]
end
