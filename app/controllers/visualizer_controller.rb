class VisualizerController < ApplicationController
	
	respond_to :json

	def sheet_flags_json
		if params[:id] == nil
			respond_with( "no sheet id specified" )
			return
		end
		sheet = Sheet.find(params[:id])
		@output = {}
		@output[:sheet] = sheet
		@output[:polygons] = sheet.mini
		@output[:flags] = sheet.flags
		respond_with(@output)
	end

	def sheet_flags_view
		@sheets = Sheet.all
	end

  def geometry_consensus
    all_polygons = Polygon.where("consensus = ?", params[:type])
    poly = []
    all_polygons.each do |p|
      poly.push(p.to_geojson)
    end

    @map = {}
    @map[:poly] = { :type => "FeatureCollection", :features => poly }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @polygon }
    end
  end

end