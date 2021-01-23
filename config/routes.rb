Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :stories, only: [:create]
  get '/stories/:id', to: 'stories#show'
end
