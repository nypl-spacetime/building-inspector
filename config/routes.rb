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


  get "fixer/color"



  get "fixer/progress_sheet"

  get "fixer/sheet" => "fixer#session_progress_for_sheet"

  get "fixer/sheet_numbers" => "fixer#session_progress_numbers_for_sheet"

  get "fixer/map" => "fixer#randomMap"

  get "color" => "fixer#color"

  # footprints
  get "building" => "fixer#building", :as => "building"
  get "fixer/building"
  get "fixer/progress", :as => "building_progress"
  get "fixer/progress_all", :as => "building_progress_all"

  # addresses
  get "numbers" => "fixer#numbers", :as => "addresses"
  get "numbers/progress" => "fixer#progress_numbers", :as => "addresses_progress"
  get "numbers/progress_all" => "fixer#progress_numbers_all", :as => "addresses_progress_all"

  get "polygonfix" => "fixer#polygonfix", :as => "polygons"

  # json flagging
  get "fixer/flag" => "fixer#flag_polygon"
  get "fixer/flagnum" => "fixer#many_flags_one_polygon"

  # visualizing
  get "viz/sheet/:id" => "visualizer#sheet_flags_json"
  get "viz/sheet" => "visualizer#sheet_flags_view"
  get "viz/building_consensus" => "visualizer#building_consensus"

  root :to => "general#home"
end
