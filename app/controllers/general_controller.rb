class GeneralController < ApplicationController

  before_filter :cookies_required, :except => :cookie_test

  def home
  	@current_page = "homepage"
    session = getSession()
    @score_geometry = 0
    @score_address = 0
    @score_polygonfix = 0
    @score_color = 0
    @score_toponym = 0
    if user_signed_in?
      @score_geometry = Flag.flags_for_user(current_user.id, "geometry")
      @score_address = Flag.flags_for_user(current_user.id, "address")
      @score_polygonfix = Flag.flags_for_user(current_user.id, "polygonfix")
      @score_color = Flag.flags_for_user(current_user.id, "color")
      @score_toponym = Flag.flags_for_user(current_user.id, "toponym")
    else
      @score_geometry = Flag.flags_for_session(session, "geometry")
      @score_address = Flag.flags_for_session(session, "address")
      @score_polygonfix = Flag.flags_for_session(session, "polygonfix")
      @score_color = Flag.flags_for_session(session, "color")
      @score_toponym = Flag.flags_for_session(session, "toponym")
    end
    @has_score = false
    @has_score = true if @score_geometry > 0 || @score_toponym > 0 || @score_address > 0 || @score_polygonfix > 0
  end

  def soon
    @current_page = "homepage"
  end

  def not_found
    @current_page = "homepage"
    render :template => "shared/404"
  end

  def home_explained
    render :partial => "partials/home-explained"
  end

  def about
    @current_page = "homepage"
  end

  def data
    @current_page = "homepage"
  end

  def win
  	ids = Flag.select(:polygon_id).where(:flag_value => "yes").order("random()").limit(30).map { |p| p.polygon_id }
	pp = Polygon.where(:id => ids).map { |p| JSON.parse(p.vectorizer_json) }
	obj = {}
	obj[:type] = "FeatureCollection"
	obj[:features] = pp
	@json = obj.to_json
  end

end
