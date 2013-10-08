class FixerController < ApplicationController
	
	before_filter :cookies_required, :except => :cookie_test
	respond_to :json

	def building
		@isNew = (cookies[:first_visit]!="no" || params[:tutorial]=="true") ? true : false
		cookies[:first_visit] = { :value => "no", :expires => 15.days.from_now }
		@map = getMap().to_json
		session = getSession()
	end

	def progress
	  	@current_page = "progress"
	end

	def sessionProgress
		# returns a GeoJSON object with the flags the session has sent so far
		# NOTE: there might be more than one flag per polygon but this only returns each polygon once
		session = getSession()
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
		@progress[:all_polygons] = Polygon.count
		@progress[:all_polygons_session] = Flag.flags_for_session(session)
		@progress[:fix_poly] = { :type => "FeatureCollection", :features => fix_poly }
		@progress[:no_poly] = { :type => "FeatureCollection", :features => no_poly }
		@progress[:yes_poly] = { :type => "FeatureCollection", :features => yes_poly }
		respond_with( @progress )
	end

	def getMap
		session = getSession()
		map = {}
		map[:map] = Sheet.random
		map[:poly] = map[:map].mini(session)
		map[:status] = {}
		map[:status][:session_id] = session
		map[:status][:map_polygons] = map[:map].polygons.count
		map[:status][:map_polygons_session] = map[:poly].count
		map[:status][:all_sheets] = Sheet.count
		map[:status][:all_polygons] = Polygon.count
		map[:status][:all_polygons_session] = Flag.flags_for_session(session)
		return map
	end

	def randomMap
		@map = getMap()
		respond_with( @map )
	end

	def flagPolygon
		session = getSession()
		@flag = Flag.new
		@flag[:is_primary] = true
		@flag[:polygon_id] = params[:i]
		@flag[:flag_value] = params[:f]
		@flag[:session_id] = session
		@flag[:flag_type] = "geometry"
		if @flag.save
			respond_with( @flag )
		else
			respond_with( @flag.errors )
		end
	end

	def getSession
		if cookies[:session] == nil || cookies[:session] == ""
			cookies[:session] = { :value => request.session_options[:id], :expires => 365.days.from_now }
		end
		cookies[:session]
	end

	def color
	end

	# checks for presence of "cookie_test" cookie
	# (should have been set by cookies_required before_filter)
	# if cookie is present, continue normal operation
	# otherwise show cookie warning at "shared/cookies_required"
	def cookie_test
		if cookies["cookie_test"].blank?
			logger.warn("=== cookies are disabled")
			render :template => "shared/cookies_required"
		else
			redirect_to(building_path)
		end
	end

protected

	# checks for presence of "cookie_test" cookie.
	# If not present, redirects to cookies_test action
	def cookies_required
		return true unless cookies["cookie_test"].blank?
		cookies["cookie_test"] = Time.now
		session[:return_to] = request.original_url
		redirect_to(cookie_test_path)
	end

end
