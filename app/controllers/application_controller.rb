class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :global_variables

  before_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if ( !request.fullpath.include?("users/sign_in") &&
         !request.fullpath.include?("users/sign_up") &&
         !request.fullpath.include?("users/password") &&
         !request.fullpath.include?("users/sign_out") &&
         !request.fullpath.include?("users/auth") &&
         !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def sort_tasks
    @global_tasks.unshift(@global_tasks.slice!(1,1)[0]) if @current_page=="polygonfix"
    @global_tasks.unshift(@global_tasks.slice!(2,1)[0]) if @current_page=="address"
    @global_tasks.unshift(@global_tasks.slice!(3,1)[0]) if @current_page=="color"
    @global_tasks.unshift(@global_tasks.slice!(4,1)[0]) if @current_page=="toponym"
    @card_url = request.protocol + request.host_with_port + ActionController::Base.helpers.asset_path("card-#{@current_page}.jpg") if @current_page=="polygonfix" || @current_page=="address" || @current_page=="color" || @current_page=="toponym" || @current_page=="geometry"
  end

  private

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    cookies.delete :session
    session[:previous_url] || root_path
  end

  def check_admin!
    # admin if (1) User is signed in and (2) Does not have an omniauth provider or has a role as 'admin'
    unless user_signed_in? and (current_user.provider.nil? or current_user.role=='admin')
      redirect_to new_user_session_path
    end
  end

  def global_variables
    @card_url = request.protocol + request.host_with_port + ActionController::Base.helpers.asset_path("card.jpg")
    @global_tasks = []
    @global_tasks.push({:score => 0, :name => "Check footprints", :path => geometry_path, :page => "geometry"})
    @global_tasks.push({:score => 0, :name => "Fix footprints", :path => polygonfix_path, :page => "polygonfix"})
    @global_tasks.push({:score => 0, :name => "Enter Addresses", :path => address_path, :page => "address"})
    @global_tasks.push({:score => 0, :name => "Classify Colors", :path => color_path, :page => "color"})
    @global_tasks.push({:score => 0, :name => "Find Place names", :path => toponym_path, :page => "toponym"})
  end

  # SESSION STUFF

  def getSession
    if cookies[:session] == nil || cookies[:session] == ""
      cookies[:session] = { :value => request.session_options[:id], :expires => 365.days.from_now }
    end
    check_for_user_session(cookies[:session]) unless user_signed_in?
    Usersession.register_user_session(current_user.id, cookies[:session]) if user_signed_in?
    cookies[:session]
  end

  # checks for presence of "cookie_test" cookie
  # (should have been set by cookies_required before_filter)
  # if cookie is present, continue normal operation
  # otherwise show cookie warning at "shared/cookies_required"
  public

  def cookie_test
    if cookies["cookie_test"].blank?
      @current_page = "homepage"
      logger.warn("=== cookies are disabled")
      render :template => "shared/cookies_required"
    else
      redirect_to(session[:return_to] ? session[:return_to] : root_path)
    end
  end

  def check_for_user_session(session)
    if session
      user = Usersession.find_user_by_session_id(session)
      if user
        @user = user
        sign_in @user, :event => :authentication
      end
    end
  end

protected

  # checks for presence of "cookie_test" cookie.
  # If not present, redirects to cookies_test action
  def cookies_required
    return true unless cookies["cookie_test"].blank?
    cookies["cookie_test"] = Time.now
    session[:return_to] = request.original_url
    redirect_to(cookie_test_path)
  end

end
