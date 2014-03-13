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
end
