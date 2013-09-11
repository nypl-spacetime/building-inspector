class FixerController < ApplicationController
	
	respond_to :json

	def building
		# puts "cookie A: #{cookies[:first_visit]}"
		@isNew = (cookies[:first_visit]!="no") ? true : false
		cookies[:first_visit] = { :value => "no", :expires => 15.days.from_now }
		# puts "cookie B: #{cookies[:first_visit]}"
	end

	def randomMap
		session = request.session_options[:id]
		@map = {}
		@map[:map] = Sheet.random
		@map[:poly] = @map[:map].mini(session)
		@map[:status] = {}
		@map[:status][:map_polygons] = @map[:map].polygons.count
		@map[:status][:map_polygons_session] = @map[:poly].count
		@map[:status][:all_sheets] = Sheet.count
		@map[:status][:all_polygons] = Polygon.count
		@map[:status][:all_polygons_session] = Flag.flags_for_session(session)
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
