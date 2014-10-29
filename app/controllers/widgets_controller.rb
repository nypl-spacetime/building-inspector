class WidgetsController < ApplicationController
  layout "widget"

  caches_page :map, :expires_in => 60.minutes

  # GET /map
  # GET /map.json
  def map
    @data = {}

    sheet = Sheet.where(:map_id => params[:map_id]).first

    if sheet != nil
      @data[:sheet] = sheet
      @data[:layer] = sheet.layer
      polys = sheet.polygons
      @data[:polygons] = polys.count
      @data[:addresses] = Consensuspolygon.find_all_by_polygon_id_and_task(polys, "address").count
      @data[:colors] = Consensuspolygon.find_all_by_polygon_id_and_task(polys, "color").count
      @data[:fixes] = Consensuspolygon.find_all_by_polygon_id_and_task(polys, "polygonfix").count
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json {
        render json: @data
      }
    end
  end
end
