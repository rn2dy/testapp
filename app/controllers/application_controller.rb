class ApplicationController < ActionController::Base
  #before_filter :authenticate_user!
  protect_from_forgery
  layout "default"

  before_filter :store_location

  def store_location
    if params[:controller] == 'bookmarklet'
      session[:user_return_to] ||= request.url
    end
  end

  def stored_location_for (resource_or_scope)
    session[:user_return_to] || super
  end
  
  def after_sign_out_path_for(resource)
    #new_user_session_path
    root_path
  end
  
end
