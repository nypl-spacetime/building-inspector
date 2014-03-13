class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :global_variables

  def sort_tasks
    @global_tasks.unshift(@global_tasks.slice!(1,1)[0]) if @current_page=="polygonfix"
    @global_tasks.unshift(@global_tasks.slice!(2,1)[0]) if @current_page=="address"
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    cookies.delete :session
    geometry_path
  end

  def check_admin!
    # admin if (1) User is signed in and (2) Does not have an omniauth provider or has a role as 'admin'
    unless user_signed_in? and (current_user.provider.nil? or current_user.role=='admin')
      redirect_to new_user_session_path
    end
  end

  def global_variables
    @global_tasks = []
    @global_tasks.push({:score => 0, :name => "Footprints", :path => geometry_path, :page => "fixer"})
    @global_tasks.push({:score => 0, :name => "Fix polygons", :path => polygons_path, :page => "polygonfix"})
    @global_tasks.push({:score => 0, :name => "Addresses", :path => address_path, :page => "address"})
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
