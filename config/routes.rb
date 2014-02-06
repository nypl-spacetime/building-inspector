Webappmini::Application.routes.draw do

  get "general/home"

  get "general/about"
  
  get "general/help"
  
  get "general/win"  

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  resources :users

  resources :polygons

  get "polygon_consensus" => "polygons#consensus"

  resources :flags

  resources :sheets

  get "cookie_test" => "fixer#cookie_test"

  get "fixer/winPoly"

  get "api/polygons"
  get "api/polygons/:flag_type" => "api#polygons"
  get "api/polygons/:flag_type/page/:page" => "api#polygons"

  get "fixer/status"

  get "fixer/allPolygons"

  get "fixer/building"

  get "fixer/color"

  get "fixer/progress"
  get "fixer/progress_all"

  get "numbers/progress" => "fixer#progress_numbers"
  get "numbers/progress_all" => "fixer#progress_numbers_all"

  get "fixer/progress_sheet"

  get "fixer/sheet" => "fixer#session_progress_for_sheet"

  get "fixer/sheet_numbers" => "fixer#session_progress_numbers_for_sheet"

  get "viz/sheet/:id" => "visualizer#sheet_flags_json"

  get "viz/sheet" => "visualizer#sheet_flags_view"

  get "fixer/map" => "fixer#randomMap"

  get "fixer/flag" => "fixer#flag_polygon"

  get "color" => "fixer#color"

  get "building" => "fixer#building"

  get "numbers" => "fixer#numbers"
  get "fixer/flagnum" => "fixer#many_flags_one_polygon"
  
  get "polygonfix" => "fixer#polygonfix"

  root :to => "general#home"
end
