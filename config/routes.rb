Webappmini::Application.routes.draw do
  get "general/home"

  get "general/about"
  
  get "general/help"
  
  get "general/win"  

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  resources :users

  resources :polygons

  resources :flags

  resources :sheets

  get "cookie_test" => "fixer#cookie_test"

  get "fixer/winPoly"

  get "fixer/status"

  get "fixer/allPolygons"

  get "fixer/building"

  get "fixer/color"

  get "fixer/progress"

  get "fixer/sheet" => "fixer#session_progress_for_sheet"

  get "viz/sheet/:id" => "visualizer#sheet_flags_json"

  get "viz/sheet" => "visualizer#sheet_flags_view"

  match "fixer/map" => "fixer#randomMap"

  match "fixer/flag" => "fixer#flagPolygon"

  match "color" => "fixer#color"
  match "building" => "fixer#building"
  
  root :to => "general#home"
end
