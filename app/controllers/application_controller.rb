class ApplicationController < ActionController::Base
  #before_filter :authenticate_user!
  protect_from_forgery
  layout "default"

  def after_sign_out_path_for(resource)
    #new_user_session_path
    root_path
  end

end
