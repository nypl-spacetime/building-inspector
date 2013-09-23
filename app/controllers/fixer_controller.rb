class FixerController < ApplicationController
	
	respond_to :json

	def building
		@isNew = (cookies[:first_visit]!="no" || params[:tutorial]=="true") ? true : false
		cookies[:first_visit] = { :value => "no", :expires => 15.days.from_now }
		if cookies[:session] == nil
			cookies[:session] = { :value => request.session_options[:id], :expires => 365.days.from_now }
		end			
	end

	def progress
	end

	def sessionProgress
		# returns a GeoJSON object with the flags the session has sent so far
		# NOTE: there might be more than one flag per polygon but this only returns each polygon once
		if cookies[:session] != nil
			session = cookies[:session]
		else
			session = request.session_options[:id]
		end
		all_polygons = Flag.progress_for_session(session)
		yes_poly = []
		no_poly = []
		fix_poly = []
		all_polygons.each do |p|
			if p[:flag_value]=="fix"
				fix_poly.push({ :type => "Feature", :properties => { :flag_value => p[:flag_value] }, :geometry => { :type => "Polygon", :coordinates => JSON.parse(p[:geometry]) } })
			elsif p[:flag_value]=="yes"
				yes_poly.push({ :type => "Feature", :properties => { :flag_value => p[:flag_value] }, :geometry => { :type => "Polygon", :coordinates => JSON.parse(p[:geometry]) } })
			elsif p[:flag_value]=="no"
				no_poly.push({ :type => "Feature", :properties => { :flag_value => p[:flag_value] }, :geometry => { :type => "Polygon", :coordinates => JSON.parse(p[:geometry]) } })
			end
		end
		@progress = {}
		@progress[:all_polygons_session] = Flag.flags_for_session(session)
		@progress[:fix_poly] = { :type => "FeatureCollection", :features => fix_poly }
		@progress[:no_poly] = { :type => "FeatureCollection", :features => no_poly }
		@progress[:yes_poly] = { :type => "FeatureCollection", :features => yes_poly }
		respond_with( @progress )
	end

	def randomMap
		if cookies[:session] != nil
			session = cookies[:session]
		else
			session = request.session_options[:id]
		end
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
