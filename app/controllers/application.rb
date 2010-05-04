class ApplicationController < ActionController::Base
  helper :all
  helper_method :admin?

  before_filter :set_current_user

  protected

  # Method to set the current user from session cookie in the instance
  # variable @current_user if it isn't set already
  def set_current_user
    @current_user ||= User.find_by_login(session[:login]) rescue nil
  end

  # Filter method to make sure the user is authorized. If not, make them log in.
  def authorized?
    if session[:auth]
      return true
    end
    flash[:error] = "please log in"
    redirect_to login_path
  end

  # Filter method to make sure the user is authorized as an administrator.
  # If not, redirect to home path.
  def admin_authorized?
    unless admin?
      flash[:error] = "unauthorized access"
      redirect_to home_path
    end
  end

  # Method to test if the current user has admin privileges.
  def admin?
    if (User.find_by_login(session[:login]).is_admin rescue nil)
      return true
    else
      return false
    end
  end

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'aa0087c92f303d2c10ba95619cde85ec'

  # passwords shouldn't be logged
  filter_parameter_logging :password
end
