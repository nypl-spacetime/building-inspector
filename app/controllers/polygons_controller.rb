class PolygonsController < ApplicationController
  layout "admin"
  before_filter :check_admin! #, :only => [:index, :edit, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /polygons
  # GET /polygons.json
  def index
    @polygons = Polygon.order(sort_column + " " + sort_direction).paginate(:page => params[:page])
    @total = Polygon.count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @polygons }
    end
  end

  # GET /polygons/1
  # GET /polygons/1.json
  def show
    @polygon = Polygon.find(params[:id])
    @map = @polygon.as_feature
    @fixes = @polygon.fixes_as_features

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @polygon }
    end
  end

  # GET /polygons/new
  # GET /polygons/new.json
  def new
    @polygon = Polygon.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @polygon }
    end
  end

  # GET /polygons/1/edit
  def edit
    @polygon = Polygon.find(params[:id])
  end

  # POST /polygons
  # POST /polygons.json
  def create
    @polygon = Polygon.new(params[:polygon])

    respond_to do |format|
      if @polygon.save
        format.html { redirect_to @polygon, notice: 'Polygon was successfully created.' }
        format.json { render json: @polygon, status: :created, location: @polygon }
      else
        format.html { render action: "new" }
        format.json { render json: @polygon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /polygons/1
  # PUT /polygons/1.json
  def update
    @polygon = Polygon.find(params[:id])

    respond_to do |format|
      if @polygon.update_attributes(params[:polygon])
        format.html { redirect_to @polygon, notice: 'Polygon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @polygon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /polygons/1
  # DELETE /polygons/1.json
  def destroy
    @polygon = Polygon.find(params[:id])
    @polygon.destroy

    respond_to do |format|
      format.html { redirect_to polygons_url }
      format.json { head :no_content }
    end
  end

  private
  
  def sort_column
    Polygon.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
