Webappmini::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users
  resources :sheets
  resources :flags
  resources :polygons

  # for session checking
  get "cookie_test", :controller => :general

  #random map provider url
  get "fixer/map", to: "fixer#randomMap"

  # admin specials
  get "polygon_consensus", to: "polygons#consensus"

  # general content stuff
  get "general/home", :as => "home"
  get "general/about", :as => "about"
  get "general/help", :as => "help"
  get "general/win", :as => "win"

  # footprints
  get "building", to: "fixer#geometry", :as => "building"
  get "geometry", to: "fixer#geometry", :as => "geometry"
  get "fixer/geometry"
  get "fixer/progress", to: "fixer#progress_geometry", :as => "building_progress"
  get "fixer/progress_all", to: "fixer#progress_geometry_all", :as => "building_progress_all"
  get "geometry/progress", to: "fixer#progress_geometry", :as => "geometry_progress"
  get "geometry/progress_all", to: "fixer#progress_geometry_all", :as => "geometry_progress_all"

  # footprints progress json endpoints
  get "geometry/progress_user", to: "fixer#session_progress_geometry_for_sheet"
  get "geometry/progress_sheet", to: "fixer#progress_sheet_geometry"

  # addresses
  get "address", to: "fixer#address", :as => "address"
  get "address/progress", to: "fixer#progress_address", :as => "address_progress"
  get "address/progress_all", to: "fixer#progress_address_all", :as => "address_progress_all"

  # address progress json endpoints
  get "address/progress_user", to: "fixer#session_progress_address_for_sheet"
  # TODO: progrees for sheet (requires consensus)

  # polygonfix
  get "polygonfix", to: "fixer#polygonfix", :as => "polygons"
  get "polygonfix/progress", to: "fixer#progress_polygonfix", :as => "polygonfix_progress"

  # polygonfix progress json endpoints
  get "polygonfix/progress_user", to: "fixer#session_progress_polygonfix_for_sheet"
  # TODO: progrees for sheet (requires consensus)

  # colors
  get "color", to: "fixer#color", :as => "color"
  get "color/progress", to: "fixer#progress_color", :as => "color_progress"
  get "color/progress_all", to: "fixer#progress_color_all", :as => "color_progress_all"

  # colors progress json endpoints
  get "color/progress_user", to: "fixer#session_progress_color_for_sheet"
  get "color/progress_sheet", to: "fixer#progress_sheet_color"

  # json flagging
  post "fixer/flag", to: "fixer#flag_polygon"
  post "fixer/flagmulti", to: "fixer#many_flags_one_polygon"

  # api endpoints
  get "api/polygons"
  get "api/polygons/:flag_type", to: "api#polygons"
  get "api/polygons/:flag_type/page/:page", to: "api#polygons"
  get "api/polygons_for_ids", to: "api#polygons_for_ids"

  root :to => "general#home"
end
