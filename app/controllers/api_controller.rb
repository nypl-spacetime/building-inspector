class ApiController < ApplicationController

    # caches_action :sheets_history, :cache_path => Proc.new { |c| "/api/sheets/#{c.params[:id]}/history" }, :layout => false, expires_in: 1.day

    # GET /api/polygons
    # GET /api/polygons/:task
    # GET /api/polygons/:task/page/:page
    # GET /api/polygons/:task/:consensus
    # GET /api/polygons/:task/:consensus/page/:page
    def polygons
        per_page = 500
        page = 1
        if params[:page] != nil && params[:page] != ''
            page = params[:page].to_i
        end
        type = params[:task]
        consensus = params[:consensus]
        offset = per_page * (page-1)
        # returns all the polygons with their consensus value
        count = 0
        columns = "polygons.id, geometry, sheet_id, CP.consensus, dn, centroid_lat, centroid_lon"
        join = " LEFT JOIN consensuspolygons AS CP ON CP.flaggable_id = polygons.id"

        if consensus != nil
            where = "CP.flaggable_type = 'Polygon' AND CP.task = "+Polygon.sanitize(type)+" AND CP.consensus = "+Polygon.sanitize(consensus)
        else
            where = "CP.flaggable_type = 'Polygon' AND CP.task = "+Polygon.sanitize(type)
        end

        count = Polygon.select("COUNT(polygons.id) as pcount").joins(join).where(where).first.pcount
        poly = Polygon.select(columns).joins(join).where(where).limit(per_page).offset(offset)

        msg = "List for informative purposes only. This is not a definitive list. This URL may be changed at any time without prior notice."

        geojson = []
        poly.each do |p|
            geojson.push(p.to_geojson)
        end

        output = {}
        output[:message] = msg
        output[:polygon_count] = count
        output[:page] = page
        output[:per_page] = per_page
        output[:total_pages] = (count.to_f / per_page.to_f).ceil
        output[:type] = "FeatureCollection"
        output[:features] = geojson
        render json: output
    end

    # GET /api/toponyms
    def toponyms
      sheetconsensus = Consensuspolygon.where(:flaggable_type => "Sheet", :task => "toponym")
      geojson = []
      if sheetconsensus
        sheetconsensus.each do |sheet|
          toponyms = JSON.parse(sheet[:consensus])
          toponyms.each do |p|
              geojson.push({
                :type => "Feature",
                :properties => {
                  :consensus => p["flag_value"],
                  :sheet_id => sheet[:flaggable_id]
                },
                :geometry => {
                  :type => "Point",
                  :coordinates => [p["longitude"].to_f, p["latitude"].to_f]
                }
              })
          end
        end
      end
      msg = "List for informative purposes only. This is not a definitive list. This URL may be changed at any time without prior notice."
      output = {}
      output[:message] = msg
      output[:toponym_count] = geojson.count
      output[:type] = "FeatureCollection"
      output[:features] = geojson
      render json: output
    end

    def consolidated
        per_page = 500
        page = 1
        if params[:page] != nil && params[:page] != ''
            page = params[:page].to_i
        end
        offset = per_page * (page-1)
        # returns all the polygons with their consensus value
        count = 0

        count = Polygon.select("COUNT(polygons.id) AS pcount").joins(:consensuspolygons).where("consensuspolygons.flaggable_type='Polygon' AND ((consensuspolygons.task=? AND consensuspolygons.consensus=?) OR consensuspolygons.task=?)","geometry","yes","polygonfix").first.pcount

        per_page = count if params[:brett]

        poly = Polygon.select("polygons.*, consensuspolygons.consensus, (SELECT consensus FROM consensuspolygons _C WHERE _C.flaggable_id=polygons.id AND _C.flaggable_type='Polygon' AND _C.task='color') AS color").joins(:consensuspolygons).where("consensuspolygons.flaggable_type='Polygon' AND ((consensuspolygons.task=? AND consensuspolygons.consensus=?) OR consensuspolygons.task=?)","geometry","yes","polygonfix").offset(offset).limit(per_page)

        msg = "List for informative purposes only. This is not a definitive list. This URL may be changed at any time without prior notice."

        geojson = []
        poly.each do |p|
            # byebug
            if p[:consensus] == "yes"
                as_geo = p.to_geojson
                as_geo[:properties][:fixed] = false
            else
                temp = JSON.parse(p[:consensus])
                as_geo = p.to_geojson
                as_geo[:properties][:fixed] = true
                as_geo[:geometry][:coordinates] = temp["features"][0]["geometry"]["coordinates"]
            end
            # adding map_id
            as_geo[:properties][:map_id] = p.sheet[:map_id]
            # adding moar consensus types
            as_geo[:properties][:consensus_color] = p.color
            consensus_address = p.consensus_address
            as_geo[:properties][:consensus_address] = consensus_address

            # put the poly geometry and address points in a new geometry
            new_geo = {}
            new_geo[:type] = "GeometryCollection"
            new_geo[:geometries] = []

            if consensus_address != nil && consensus_address != "N/A" && consensus_address != "NONE"
                # address points and poly geometry live together
                addresses = JSON.parse(consensus_address)

                # put address properties in an array in the poly properties
                as_geo[:properties][:consensus_address] = addresses["features"].each_with_index.map {|f,i| f["properties"]}

                new_geo[:geometries] = addresses["features"].map { |f|  f["geometry"]}
            end
            new_geo[:geometries].unshift(as_geo[:geometry])

            # replace the poly geometry with the new one
            as_geo[:geometry] = new_geo

            geojson.push(as_geo)
        end

        output = {}
        output[:message] = msg
        output[:polygon_count] = count
        output[:page] = page
        output[:per_page] = per_page
        output[:total_pages] = (count.to_f / per_page.to_f).ceil
        output[:type] = "FeatureCollection"
        output[:features] = geojson
        render json: output
    end


    # GET /api/sheets
    def sheets_all
        # get all sheets
        sheets = Sheet.all
        output = {}
        geojson = []
        sheets.each do |s|
            geojson.push(s.to_geojson)
        end
        output = {}
        output[:type] = "FeatureCollection"
        output[:features] = geojson
        render json: output
    end

    # GET /api/sheets/:id/history/:task
    def sheets_history
        # get all flags for all polygons for a sheet
        # return them as geojson in chronological order
        begin
            sheet = Sheet.find params[:id]
        rescue
        end
        geojson = []
        if sheet
            for_task = ""
            task = Sheet.sanitize(params[:task])
            for_task = " AND flag_type=#{task} " if params[:task] != nil
            flags = Flag.where("(flaggable_type = 'Sheet' AND flaggable_id = ?) OR (flaggable_type = 'Polygon' AND flaggable_id IN (?)) #{for_task}", sheet[:id],sheet.polygons.pluck(:id)).order(:created_at)

            flags.each do |f|
                geojson.push(f.to_geojson)
            end
        end
        output = {}
        output[:type] = "FeatureCollection"
        output[:features] = geojson
        render json: output
    end

    # GET /api/sheets/:id/polygons
    def sheets_polygons
        begin
            sheet = Sheet.find params[:id]
        rescue
        end
        geojson = []
        if sheet
            poly = sheet.polygons
            poly.each do |p|
                geojson.push(p.to_geojson)
            end
        end
        output = {}
        output[:type] = "FeatureCollection"
        output[:features] = geojson
        render json: output
    end

    # GET /api/sheets/:id/toponyms
    def sheets_toponyms
        begin
            sheet = Sheet.find params[:id]
        rescue
        end
        geojson = []
        if sheet
            toponyms = JSON.parse(sheet.consensus("toponym"))
            toponyms.each do |p|
                geojson.push({ :type => "Feature", :properties => { :consensus => p["flag_value"], :sheet_id => sheet[:id] }, :geometry => { :type => "Point", :coordinates => [p["longitude"].to_f, p["latitude"].to_f]  } })
            end
        end
        output = {}
        output[:type] = "FeatureCollection"
        output[:features] = geojson
        render json: output
    end

    def polygons_for_ids
        per_page = 500
        page = 1
        count = 0
        if params[:list] == nil
            respond_with("no comma-separated list of ids provided")
            return
        end
        if params[:page] != nil && params[:page] != ''
            page = params[:page].to_i
        end
        offset = per_page * (page-1)
        # returns all the polygons with their consensus value
        columns = "id, geometry, sheet_id, dn, centroid_lat, centroid_lon"
        ids = params[:list].split(",").map {|id| id.to_i}
        if ids.count > 0
            count = Polygon.select("COUNT(id) as pcount").where("id IN (?)", ids).first.pcount
            poly = Polygon.select(columns).where("id IN (?)", ids).offset(offset)
        end
        msg = "List for informative purposes only. This is not a definitive list. This URL may be changed at any time without prior notice."

        geojson = []

        if poly
            poly.each do |p|
                geojson.push(p.to_geojson)
            end
        end

        output = {}
        output[:message] = msg
        output[:polygon_count] = count
        output[:page] = page
        output[:per_page] = per_page
        output[:total_pages] = (count.to_f / per_page.to_f).ceil
        output[:type] = "FeatureCollection"
        output[:features] = geojson
        render json: output
    end

end
