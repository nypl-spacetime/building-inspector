class WidgetsController < ApplicationController
  layout "widget"

  # GET /sheet
  # GET /sheet.json
  def sheet
    @sheet = Sheet.find(params[:id])

    # TODO: allow for admin review of progress in all tasks
    if params[:type] == nil # ALWAYS nil FOR NOW
      params[:type] = "geometry"
    end

    all_polygons = Sheet.progress_for_task(@sheet.id, params[:type])

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

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sheet }
    end
  end
end
