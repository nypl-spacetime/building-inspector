require 'sinatra'
require 'sinatra/content_for'
require 'haml'
require 'sass'
require 'compass'
require 'coffee-script'

helpers Sinatra::ContentFor

configure do
	Compass.configuration do |config|
		config.project_path = File.dirname(__FILE__)
    	config.sass_dir = 'views'
	end

	mime_type :json, "text/json"
	mime_type :shp, "text/shp"
	mime_type :dbf, "text/dbf"

	set :haml, { :format => :html5 }
	set :sass, Compass.sass_engine_options
	set :scss, Compass.sass_engine_options
end

get '/stylesheets/:name.css' do
	set :views,   File.dirname(__FILE__)    + '/views/scss'
	content_type 'text/css', :charset => 'utf-8'
	scss(:"#{params[:name]}")
end

get '/js/:name.js' do
	set :views,   File.dirname(__FILE__)    + '/views/coffeescript'
	content_type 'text/javascript'
	coffee(:"#{params[:name]}")
end

get '/' do
	set :views,   File.dirname(__FILE__)    + '/views'
	erb :building, :layout => :layout
	# File.open('public/index.html', File::RDONLY)
end

get '/color' do
	set :views,   File.dirname(__FILE__)    + '/views'
	erb :color, :layout => :layout
	# File.open('public/index.html', File::RDONLY)
end

get '/building' do
	set :views,   File.dirname(__FILE__)    + '/views'
	erb :building, :layout => :layout
	# File.open('public/index.html', File::RDONLY)
end

