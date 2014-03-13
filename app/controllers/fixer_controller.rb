class FixerController < ApplicationController

	before_filter :cookies_required, :except => :cookie_test
	respond_to :json

  # GEOMETRY

	def geometry
	  @current_page = "fixer"
		@isNew = (cookies[:first_visit]!="no" || params[:tutorial]=="true") ? true : false
		cookies[:first_visit] = { :value => "no", :expires => 15.days.from_now }
		@map = getMap("geometry").to_json
	end

	def progress_geometry
	  @current_page = "progress"
		# returns a GeoJSON object with the flags the session has sent so far
		# NOTE: there might be more than one flag per polygon but this only returns each polygon once
		session = getSession()
		@progress = {}
		if user_signed_in?
			@progress[:counts] = Flag.grouped_flags_for_user(current_user.id)
			@progress[:all_polygons_session] = Flag.flags_for_user(current_user.id)
		else
			@progress[:counts] = Flag.grouped_flags_for_session(session)
			@progress[:all_polygons_session] = Flag.flags_for_session(session)
		end
		@progress = @progress.to_json
	end

	def progress_geometry_all
  	@current_page = "progress_all"
		# returns a GeoJSON object with the flags the session has sent so far
		# NOTE: there might be more than one flag per polygon but this only returns each polygon once
		@progress = {}
		@progress[:counts] = Polygon.grouped_by_sheet
		if user_signed_in?
			@progress[:all_polygons_session] = Flag.flags_for_user(current_user.id)
		else
			@progress[:all_polygons_session] = Flag.flags_for_session(session)
		end
		@progress = @progress.to_json
	end

  def session_progress_for_sheet
    session = getSession()
    if params[:id] == nil
      respond_with("no id provided")
      return
    end
    if user_signed_in?
      all_polygons = Flag.flags_for_sheet_for_user(params[:id],current_user.id)
    else
      all_polygons = Flag.flags_for_sheet_for_session(params[:id],session)
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
    @progress[:fix_poly] = { :type => "FeatureCollection", :features => fix_poly }
    @progress[:no_poly] = { :type => "FeatureCollection", :features => no_poly }
    @progress[:yes_poly] = { :type => "FeatureCollection", :features => yes_poly }
    respond_with( @progress )
  end

  def progress_sheet
      all_polygons = Polygon.select("id, consensus, dn, sheet_id, geometry").where(:sheet_id => params[:id])

      fix_poly = []
      yes_poly = []
      no_poly = []
      nil_poly = []

      all_polygons.each do |p|
        if p[:consensus]=="fix"
          fix_poly.push(p.to_geojson)
        elsif p[:consensus]=="yes"
          yes_poly.push(p.to_geojson)
        elsif p[:consensus]=="no"
          no_poly.push(p.to_geojson)
        else
          nil_poly.push(p.to_geojson)
        end
      end

      @map = {}
      @map[:fix_poly] = { :type => "FeatureCollection", :features => fix_poly }
      @map[:no_poly] = { :type => "FeatureCollection", :features => no_poly }
      @map[:yes_poly] = { :type => "FeatureCollection", :features => yes_poly }
      @map[:nil_poly] = { :type => "FeatureCollection", :features => nil_poly }
    respond_with( @map )
  end

  # ADDRESS

	def address
		@current_page = "address"
		sort_tasks()
		@isNew = (cookies[:first_visit]!="no" || params[:tutorial]=="true") ? true : false
		cookies[:first_visit] = { :value => "no", :expires => 15.days.from_now }
		@map = getMap("address").to_json
	end

	def progress_address
	  	@current_page = "progress_address"
		# returns a GeoJSON object with the flags the session has sent so far
		# NOTE: there might be more than one flag per polygon but this only returns each polygon once
		session = getSession()
		@progress = {}
		if user_signed_in?
			@progress[:counts] = Flag.grouped_flags_for_user(current_user.id, "address")
			@progress[:all_polygons_session] = Flag.flags_for_user(current_user.id, "address")
		else
			@progress[:counts] = Flag.grouped_flags_for_session(session, "address")
			@progress[:all_polygons_session] = Flag.flags_for_session(session, "address")
		end
		@progress = @progress.to_json
	end

	def progress_address_all
	  	@current_page = "progress_address_all"
		# returns a GeoJSON object with the flags the session has sent so far
		# NOTE: there might be more than one flag per polygon but this only returns each polygon once
		@progress = {}
		@progress[:counts] = Polygon.grouped_by_sheet("address")
		if user_signed_in?
			@progress[:all_polygons_session] = Flag.flags_for_user(current_user.id, "address")
		else
			@progress[:all_polygons_session] = Flag.flags_for_session(session, "address")
		end
		@progress = @progress.to_json
	end

  def session_progress_address_for_sheet
    # the address progress for a given sheet id
    session = getSession()

    if params[:id] == nil
      respond_with("no id provided")
      return
    end

    if user_signed_in?
      all_flags = Flag.flags_for_sheet_for_user(params[:id], current_user.id, "address")
    else
      all_flags = Flag.flags_for_sheet_for_session(params[:id], session, "address")
    end

    poly = []

    all_flags.each do |f|
      poly.push(f.as_feature)
    end
    @progress = {}
    @progress[:poly] = { :type => "FeatureCollection", :features => poly }
    respond_with( @progress )
  end

  # POLYGONFIX

  def polygonfix
    @current_page = "polygonfix"
    sort_tasks()
    @isNew = (cookies[:first_visit]!="no" || params[:tutorial]=="true") ? true : false
    cookies[:first_visit] = { :value => "no", :expires => 15.days.from_now }
    @map = getMap("polygonfix").to_json
  end

  def progress_polygonfix
    @current_page = "progress_polygonfix"
    # returns a GeoJSON object with the flags the session has sent so far
    # NOTE: there might be more than one flag per polygon but this only returns each polygon once
    session = getSession()
    @progress = {}
    if user_signed_in?
      @progress[:counts] = Flag.grouped_flags_for_user(current_user.id, "polygonfix")
      @progress[:all_polygons_session] = Flag.flags_for_user(current_user.id, "polygonfix")
    else
      @progress[:counts] = Flag.grouped_flags_for_session(session, "polygonfix")
      @progress[:all_polygons_session] = Flag.flags_for_session(session, "polygonfix")
    end
    @progress = @progress.to_json
  end

  def session_progress_polygonfix_for_sheet
    session = getSession()
    if params[:id] == nil
      respond_with("no id provided")
      return
    end
    if user_signed_in?
      all_polygons = Flag.flags_for_sheet_for_user(params[:id],current_user.id, "polygonfix")
    else
      all_polygons = Flag.flags_for_sheet_for_session(params[:id],session, "polygonfix")
    end
    poly = []
    all_polygons.each do |p|
      poly.push({ :type => "Feature", :properties => { :flag_value => p[:flag_value] }, :geometry => { :type => "Polygon", :coordinates => JSON.parse((p[:flag_value]!="NOFIX" ? p[:flag_value] : p[:geometry])) } })
    end
    @progress = {}
    @progress[:poly] = { :type => "FeatureCollection", :features => poly }
    respond_with( @progress )
  end

  # OTHER

	def status
	  	@current_page = "status"
	end

	def getMap(type="geometry")
		session = getSession()
		map = {}
		# map[:map] = Sheet.random
		map[:map] = Sheet.random_unprocessed(type)
		map[:poly] = map[:map].mini(session, type)
		map[:status] = {}
		map[:status][:session_id] = session
		map[:status][:map_polygons] = map[:map].polygons.count
		map[:status][:map_polygons_session] = map[:poly].count
		map[:status][:all_sheets] = Sheet.count
		map[:status][:all_polygons] = Polygon.count
		if user_signed_in?
		  map[:status][:all_polygons_session] = Flag.flags_for_user(current_user.id, type)
		else
		  map[:status][:all_polygons_session] = Flag.flags_for_session(session, type)
		end
		return map
	end

	def randomMap(type="geometry")
    if params[:type] != nil
      type = params[:type]
    end

		@map = getMap(type)
		respond_with( @map )
	end

  # FLAGGING

	def flag_polygon(type="geometry")
	    if params[:t] != nil
	      type = params[:t]
	    end
		session = getSession()
		@flag = Flag.new
		@flag[:is_primary] = true
		@flag[:polygon_id] = params[:i]
		@flag[:flag_value] = params[:f]
		@flag[:session_id] = session
		@flag[:flag_type] = type
		if @flag.save
			fl = Polygon.connection.execute("UPDATE polygons SET flag_count = flag_count+1 WHERE id = #{params[:i]}")
			respond_with( @flag )
		else
			respond_with( @flag.errors )
		end
	end

  def many_flags_one_polygon
    session = getSession()
    # assuming json like so:
    # id: poly_id
    # flags: "lat,lng,value|lat,lng,value|lat,lng,value|..."
    flags = params[:f].split("|")
    poly_id = params[:i]
    type = params[:t]
    if poly_id == nil || flags == nil || flags.count <= 0
        respond_with( "empty_poly" )
        return
    end
    uniques = []
    flags.each do |f|
    	contents = f.split(",")
    	# at least have a value
        if contents[2] == nil || uniques.index(contents[2]) != nil
            next
        end
        flag = Flag.new
        flag[:is_primary] = true
        flag[:polygon_id] = poly_id
        flag[:flag_value] = contents[2]
        if contents[0] != ""
        	flag[:latitude] = contents[0]
        end
        if contents[1] != ""
          flag[:longitude] = contents[1]
        end
        flag[:session_id] = session
        flag[:flag_type] = type
        begin
        	flag.save
          uniques.push(flag)
        rescue ActiveRecord::RecordNotUnique => e
	        next if(e.message =~ /unique.*constraint.*index_flags_on_session_id/)
          raise
	      end
    end
    respond_with( uniques )
  end

  # SESSION STUFF

	def getSession
		if cookies[:session] == nil || cookies[:session] == ""
			cookies[:session] = { :value => request.session_options[:id], :expires => 365.days.from_now }
		end
		check_for_user_session(cookies[:session]) unless user_signed_in?
		Usersession.register_user_session(current_user.id, cookies[:session]) if user_signed_in?
		cookies[:session]
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
			redirect_to(session[:return_to])
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
