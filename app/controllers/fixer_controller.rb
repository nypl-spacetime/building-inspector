class FixerController < ApplicationController
	
	respond_to :json

	def building
	end

	def randomMap
		@map = Sheet.random
		@map[:poly] = @map.mini(request.session_options[:id]) # this is deprecated but cannot figure out how to use attr_writer for the love of me
		respond_with( @map )
	end

	def flagPolygon
		@flag = Flag.new
		@flag[:is_primary] = true
		@flag[:polygon_id] = params[:i]
		@flag[:flag_value] = params[:f]
		@flag[:session_id] = request.session_options[:id]
		@flag[:flag_type] = "geometry"
		if @flag.save
			respond_with( @flag )
		else
			respond_with( @flag.errors )
		end
	end

	def color
	end
end
