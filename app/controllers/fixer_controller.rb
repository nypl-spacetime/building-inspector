class FixerController < ApplicationController

	before_filter :cookies_required, :except => :cookie_test
	respond_to :json

  # GEOMETRY

	def geometry
    task = "geometry"
    @current_page = task
    sort_tasks()
    @isNew = checkNewness(task)
    map_obj = getMap(task)
    @map = map_obj.to_json
	end

	def progress_geometry
    getProgress("geometry","user","progress")
	end

	def progress_geometry_all
    getProgress("geometry","all","progress_all")
	end

  # - JSON endpoints for progress

  def session_progress_geometry_for_sheet
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

  def progress_sheet_geometry
    all_polygons = Sheet.progress_for_task(params[:id], "geometry")

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
    task = "address"
    @current_page = task
    sort_tasks()
    @isNew = checkNewness(task)
    map_obj = getMap(task)
    @map = map_obj.to_json
	end

	def progress_address
    getProgress("address","user","progress_address")
	end

	def progress_address_all
    getProgress("address","all","progress_address_all")
	end

  # - JSON endpoints for progress

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

  # TOPONYM

  def toponym
    task = "toponym"
    @current_page = task
    sort_tasks()
    @isNew = checkNewness(task)
    map_obj = getMap(task)

    topo_features = toponyms_for_map(map_obj[:map][:id])

    map_obj[:toponyms] = topo_features
    @map = map_obj.to_json
  end

  def progress_toponym
    getProgress("toponym","user","progress_toponym")
  end

  def progress_toponym_all
    getProgress("toponym","all","progress_toponym_all")
  end

  def toponyms_for_map(id)
    # so the user sees what s/he's done so far in this sheet
    session = getSession()

    if user_signed_in?
      topo_features = toponyms_as_features(id, current_user.id, "user")
    else
      topo_features = toponyms_as_features(id, session, "session")
    end

  end

  # - JSON endpoints for progress

  def session_progress_toponym_for_sheet
    # the toponym progress for a given sheet id
    session = getSession()

    if params[:id] == nil
      respond_with("no id provided")
      return
    end

    if user_signed_in?
      topo_features = toponyms_as_features(params[:id], current_user.id, "user")
    else
      topo_features = toponyms_as_features(params[:id], session, "session")
    end

    @progress = {}
    @progress[:poly] = topo_features
    respond_with( @progress )
  end

  def toponyms_as_features(sheet_id, user_or_session, type)
    if type == "user"
      all_flags = Flag.flags_for_sheet_for_user(sheet_id, user_or_session, "toponym")
    else
      all_flags = Flag.flags_for_sheet_for_session(sheet_id, user_or_session, "toponym")
    end

    poly = []

    all_flags.each do |f|
      poly.push(f.as_feature)
    end

    { :type => "FeatureCollection", :features => poly }
  end

  # POLYGONFIX

  def polygonfix
    task = "polygonfix"
    @current_page = task
    sort_tasks()
    @isNew = checkNewness(task)
    map_obj = getMap(task)
    @map = map_obj.to_json
  end

  def progress_polygonfix
    getProgress("polygonfix","user","progress_polygonfix")
  end

  # - JSON endpoints for progress

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

  # COLOR

  def color
    task = "color"
    @current_page = task
    sort_tasks()
    @isNew = checkNewness(task)
    map_obj = getMap(task)
    @map = map_obj.to_json
  end

  def progress_color
    getProgress("color","user","progress_color")
  end

  def progress_color_all
    getProgress("color","all","progress_color_all")
  end

  # - JSON endpoints for progress

  def session_progress_color_for_sheet
    session = getSession()
    if params[:id] == nil
      respond_with("no id provided")
      return
    end
    if user_signed_in?
      all_polygons = Flag.flags_for_sheet_for_user(params[:id],current_user.id, "color")
    else
      all_polygons = Flag.flags_for_sheet_for_session(params[:id],session, "color")
    end
    pink_poly = []
    blue_poly = []
    yellow_poly = []
    green_poly = []
    gray_poly = []
    all_polygons.each do |p|
      if p[:flag_value]=="yellow"
        yellow_poly.push({ :type => "Feature", :properties => { :flag_value => p[:flag_value] }, :geometry => { :type => "Polygon", :coordinates => JSON.parse(p[:geometry]) } })
      elsif p[:flag_value]=="pink"
        pink_poly.push({ :type => "Feature", :properties => { :flag_value => p[:flag_value] }, :geometry => { :type => "Polygon", :coordinates => JSON.parse(p[:geometry]) } })
      elsif p[:flag_value]=="blue"
        blue_poly.push({ :type => "Feature", :properties => { :flag_value => p[:flag_value] }, :geometry => { :type => "Polygon", :coordinates => JSON.parse(p[:geometry]) } })
      elsif p[:flag_value]=="green"
        green_poly.push({ :type => "Feature", :properties => { :flag_value => p[:flag_value] }, :geometry => { :type => "Polygon", :coordinates => JSON.parse(p[:geometry]) } })
      elsif p[:flag_value]=="gray"
        gray_poly.push({ :type => "Feature", :properties => { :flag_value => p[:flag_value] }, :geometry => { :type => "Polygon", :coordinates => JSON.parse(p[:geometry]) } })
      end
    end
    @progress = {}
    @progress[:yellow_poly] = { :type => "FeatureCollection", :features => yellow_poly }
    @progress[:blue_poly] = { :type => "FeatureCollection", :features => blue_poly }
    @progress[:pink_poly] = { :type => "FeatureCollection", :features => pink_poly }
    @progress[:green_poly] = { :type => "FeatureCollection", :features => green_poly }
    @progress[:gray_poly] = { :type => "FeatureCollection", :features => gray_poly }
    respond_with( @progress )
  end

  def progress_sheet_color
    all_polygons = Sheet.progress_for_task(params[:id], "color")

    yellow_poly = []
    pink_poly = []
    blue_poly = []
    green_poly = []
    gray_poly = []
    nil_poly = []

    all_polygons.each do |p|
      if p[:consensus]=="yellow"
        yellow_poly.push(p.to_geojson)
      elsif p[:consensus]=="pink"
        pink_poly.push(p.to_geojson)
      elsif p[:consensus]=="blue"
        blue_poly.push(p.to_geojson)
      elsif p[:flag_value]=="green"
        green_poly.push(p.to_geojson)
      elsif p[:flag_value]=="gray"
        gray_poly.push(p.to_geojson)
      else
        nil_poly.push(p.to_geojson)
      end
    end

    @map = {}
    @map[:yellow_poly] = { :type => "FeatureCollection", :features => yellow_poly }
    @map[:blue_poly] = { :type => "FeatureCollection", :features => blue_poly }
    @map[:pink_poly] = { :type => "FeatureCollection", :features => pink_poly }
    @map[:green_poly] = { :type => "FeatureCollection", :features => green_poly }
    @map[:gray_poly] = { :type => "FeatureCollection", :features => gray_poly }
    @map[:nil_poly] = { :type => "FeatureCollection", :features => nil_poly }
    respond_with( @map )
  end

  # generic methods

  def checkNewness(task)
    isNew = (cookies["#{task}_first_visit"]!="no" || params[:tutorial]=="true") ? true : false
    cookies["#{task}_first_visit"] = { :value => "no", :expires => 15.days.from_now }
    return isNew
  end

  def getProgress(type, scope, pagename)
    @current_page = pagename
    # returns a GeoJSON object with the flags the session has sent so far
    # NOTE: there might be more than one flag per polygon but this only returns each polygon once
    layer_id = params[:layer_id]
    @progress = getProgressData(type,scope,layer_id).to_json
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @progress }
    end
  end

  def getProgressData(task, mode, layer_id=nil)
    if !layer_id
      layer = Layer.first
      layer_id = layer[:id]
    else
      layer = Layer.find(layer_id)
    end
    session = getSession()
    progress = {}
    progress[:layers] = Layer.all(:order => :id)
    progress[:layer] = layer
    progress[:counts] = Polygon.grouped_by_sheet(layer_id) unless mode == "user"
    if user_signed_in?
      if mode != "all"
        progress[:counts] = Flag.grouped_flags_for_user(current_user.id, layer_id, task) if task == "toponym"
        progress[:counts] = Flag.grouped_flags_for_user(current_user.id, layer_id, task) if task != "toponym"
      end
      progress[:all_polygons_session] = Flag.flags_for_user(current_user.id, task)
    else
      if mode != "all"
        progress[:counts] = Flag.grouped_flags_for_session(session, layer_id, task) if task == "toponym"
        progress[:counts] = Flag.grouped_flags_for_session(session, layer_id, task) if task != "toponym"
      end
      progress[:all_polygons_session] = Flag.flags_for_session(session, task)
    end
    return progress
  end

	def status
	  	@current_page = "status"
	end

	def getMap(type="geometry")
		session = getSession()
		map = {}
		# map[:map] = Sheet.random
		map[:map] = Sheet.random_unprocessed(type)

    map[:status] = {}
    map[:status][:session_id] = session

    if user_signed_in?
      map[:status][:all_polygons_session] = Flag.flags_for_user(current_user.id, type)
    else
      map[:status][:all_polygons_session] = Flag.flags_for_session(session, type)
    end

    if map[:map] == nil
      # no map was found, send empty stuff
      map[:tileset] = Layer.first
      map[:poly] = []
      map[:status][:map_polygons] = 0
      map[:status][:map_polygons_session] = 0
      map[:status][:all_sheets] = Sheet.count
      map[:status][:all_polygons] = Polygon.count
      return map
    end

    map[:tileset] = map[:map].layer
		map[:poly] = map[:map].polygons_for_task(session, type)
		map[:status][:map_polygons] = map[:map].polygons.count
		map[:status][:map_polygons_session] = map[:poly].count
		map[:status][:all_sheets] = Sheet.count
		map[:status][:all_polygons] = Polygon.count
		return map
	end

  # invoked from inspectors for 2..n map
  def randomMap(type="geometry")
    if params[:type] != nil
      type = params[:type]
    end

    @map = getMap(type)

    if type=="toponym"
      topo_features = toponyms_for_map(@map[:map][:id])

      @map[:toponyms] = topo_features
    end

    respond_with( @map )
  end

  # FLAGGING

  def apply_flags_to_polygon
    session = getSession()
    # assuming json like so:
    # i: item_id
    # ft: flaggable_type
    # f: "value=lat=lng|value=lat=lng|value=lat=lng|..."
    flags = params[:f].split("|")
    flaggable_id = params[:i]
    flaggable_type = params[:ft]
    type = params[:t]
    if flaggable_id == nil || flags == nil
        render :text => "empty_poly"
        return
    end

    uniques = []
    flags.each do |f|
    	contents = f.split("=")
    	# at least have a value
        if contents[0] == nil # || uniques.index(contents[0]) != nil
            next
        end
        flag = Flag.new
        flag[:is_primary] = true
        flag[:flaggable_id] = flaggable_id
        flag[:flaggable_type] = flaggable_type
        flag[:flag_value] = contents[0]
        if contents[1] != ""
        	flag[:latitude] = contents[1]
        end
        if contents[2] != ""
          flag[:longitude] = contents[2]
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
    render :json => { :flags => uniques }
  end

  def delete_flags_for_session
    session = getSession()
    # assuming json like so:
    # f: "id|id|id..."
    flag_ids = params[:f].split("|")
    flags = Flag.flags_by_id_for_session(flag_ids, session)

    flags.each do |f|
      if f[:flaggable_type] == "Polygon"
        # remove consensus for that polygon task
        # TODO: consensus is still poly-based so change this in the future to support sheet/any
        Consensuspolygon.remove_from_flaggable_id_and_type(f[:polygon_id], "Polygon", f[:flag_type])
      elsif f[:flaggable_type] == "Sheet"
        # TODO: consensus is still poly-based so change this in the future to support sheet/any
      end
      f.destroy
    end

    render :json => true
  end

end
