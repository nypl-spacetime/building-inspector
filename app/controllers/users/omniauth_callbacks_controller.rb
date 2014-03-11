class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in @user, :event => :authentication
      redirect_to geometry_path
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to geometry_path
    end
  end

  def google_oauth2
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in @user, :event => :authentication
      redirect_to geometry_path
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to geometry_path
    end
  end

  def twitter
    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      sign_in @user, :event => :authentication
      redirect_to geometry_path
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      redirect_to geometry_path
    end
  end

end