class FixerController < ApplicationController
	
	before_filter :cookies_required, :except => :cookie_test
	respond_to :json

	def building
	  	@current_page = "fixer"
		@isNew = (cookies[:first_visit]!="no" || params[:tutorial]=="true") ? true : false
		cookies[:first_visit] = { :value => "no", :expires => 15.days.from_now }
		@map = getMap().to_json
		session = getSession()
	end

	def dbtest
	  	@current_page = "progress"
	end

	def progress
	  	@current_page = "progress"
	end

	def status
	  	@current_page = "status"
	end

	def sessionProgress
		# returns a GeoJSON object with the flags the session has sent so far
		# NOTE: there might be more than one flag per polygon but this only returns each polygon once
		session = getSession()
		if user_signed_in?
      all_polygons = Flag.progress_for_user(current_user.id)
    else
      all_polygons = Flag.progress_for_session(session)
    end 
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
		if user_signed_in?
      @progress[:all_polygons_session] = Flag.flags_for_user(current_user.id)
    else
      @progress[:all_polygons_session] = Flag.flags_for_session(session)
    end 
		@progress[:fix_poly] = { :type => "FeatureCollection", :features => fix_poly }
		@progress[:no_poly] = { :type => "FeatureCollection", :features => no_poly }
		@progress[:yes_poly] = { :type => "FeatureCollection", :features => yes_poly }
		respond_with( @progress )
	end

	def allPolygons
		all_polygons = Polygon.select("status, id, sheet_id, geometry, dn")
		respond_with( all_polygons )
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
		if user_signed_in?
		  map[:status][:all_polygons_session] = Flag.flags_for_user(current_user.id)
		else
		  map[:status][:all_polygons_session] = Flag.flags_for_session(session)
		end		
		return map
	end

	def randomMap
		@map = getMap()
		respond_with( @map )
	end

	def flagManyPolygons
		session = getSession()
		# assuming json like so:
		# poly: "[ [id, flag], [id, flag], ... ]"
		poly = JSON.parse(params[:poly])
		if poly == nil || poly.count <= 0
			respond_with( "empty_poly" )
			return
		end
		ids = []
		poly.each do |p|
			if p[0] == nil || p[1] == nil
				next
			end
			flag = Flag.new
			flag[:is_primary] = true
			flag[:polygon_id] = p[0]
			flag[:flag_value] = p[1]
			flag[:session_id] = session
			flag[:flag_type] = "geometry"
			if flag.save
				ids.push(p[0])
			end
		end
		fl = Polygon.connection.execute("UPDATE polygons SET flag_count = flag_count+1 WHERE id IN (#{ids.join(',')})")
		respond_with( "flag_success" )
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
			fl = Polygon.connection.execute("UPDATE polygons SET flag_count = flag_count+1 WHERE id = #{params[:i]}")
			respond_with( @flag )
		else
			respond_with( @flag.errors )
		end
	end

	def getSession
		if cookies[:session] == nil || cookies[:session] == ""
			cookies[:session] = { :value => request.session_options[:id], :expires => 365.days.from_now }			
		end
		check_for_user_session(cookies[:session]) unless user_signed_in?
		Usersession.register_user_session(current_user.id, cookies[:session]) if user_signed_in?
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
	
	def check_for_user_session(session)
	  if session
	    user = Usersession.find_user_by_session_id(session)
	    if user
	      @user = user
	      sign_in @user, :event => :authentication
	    end
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
