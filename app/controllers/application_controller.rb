class ApplicationController < ActionController::Base
  protect_from_forgery
  
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
  
end
