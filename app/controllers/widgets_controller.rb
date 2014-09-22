class WidgetsController < ApplicationController
  layout "widget"

  # GET /map
  # GET /map.json
  def map
    @sheet = Sheet.where(:map_id => params[:map_id]).first

    respond_to do |format|
      format.html # index.html.erb
      format.json {
        if @sheet != nil
          all_polygons = Sheet.progress_for_task(@sheet.id, "geometry")

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
        end
        render json: @map
      }
    end
  end
end
