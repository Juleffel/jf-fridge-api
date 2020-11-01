Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :ingredients
  post '/matching_recipes', to: 'ingredients#matching_recipes', as: 'matching_recipes'
  post '/full_match_recipes', to: 'ingredients#full_match_recipes', as: 'full_match_recipes'
end
