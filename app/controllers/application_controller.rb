class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "default"

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

end
