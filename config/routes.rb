Webappmini::Application.routes.draw do
  devise_for :users

  resources :polygons

  resources :flags

  resources :sheets

  get "fixer/building"

  get "fixer/color"

  match "fixer/map" => "fixer#randomMap"

  match "fixer/flag" => "fixer#flagPolygon"

  match "color" => "fixer#color"
  match "building" => "fixer#building"
  
  root :to => "fixer#building"
end
