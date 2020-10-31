Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :ingredients do
    get 'matching_recipes', on: :collection
    get 'full_match_recipes', on: :collection
  end
end
