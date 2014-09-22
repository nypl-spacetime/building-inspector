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
      @data[:polygons] = Sheet.polygons_for_task(sheet.id, nil, "address").count
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json {
        render json: @data
      }
    end
  end
end
