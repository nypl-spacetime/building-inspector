class GeneralController < ApplicationController

  before_filter :cookies_required, :except => :cookie_test

  def home
    layer = Layer.order(:created_at).last
    @sticker_url = "#{geometry_path}?layer=#{layer[:id]}" || nil
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
      # rankings only happen for logged in users
      @rank_geometry = UserScores.rank_for_user_task(current_user.id, "geometry")
      @rank_address = UserScores.rank_for_user_task(current_user.id, "address")
      @rank_polygonfix = UserScores.rank_for_user_task(current_user.id, "polygonfix")
      @rank_color = UserScores.rank_for_user_task(current_user.id, "color")
      @rank_toponym = UserScores.rank_for_user_task(current_user.id, "toponym")
    else
      @score_geometry = Flag.flags_for_session(session, "geometry")
      @score_address = Flag.flags_for_session(session, "address")
      @score_polygonfix = Flag.flags_for_session(session, "polygonfix")
      @score_color = Flag.flags_for_session(session, "color")
      @score_toponym = Flag.flags_for_session(session, "toponym")
    end

    @user_count = User.count

    @has_score = false
    @has_score = true if @score_geometry > 0 || @score_toponym > 0 || @score_address > 0 || @score_polygonfix > 0
  end

  def random
    # redirects to a random task
    list = @global_tasks
    list = list.select { |i| i if i[:page] != params[:not] } if params[:not] != nil
    redirect_to list.sample[:path]
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

end
