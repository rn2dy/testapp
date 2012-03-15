class RegistrationsController < Devise::RegistrationsController
  
  def create
    # custome sign up logic
    params[:user] = params[:user].merge(password_confirmation: params[:user][:password])
    build_resource
    if resource.save
      if resource.active_for_authentication?
        sign_in(resource_name, resource)
        Notifier.registered(params[:user][:email]).deliver
        return render :json => { :success => true, :redirect => after_sign_up_path_for(resource) }
      else
        expire_session_data_after_sign_in!
        return render :json => { :success => true, :redirect => after_inactive_sign_up_path_for(resource) }
      end
    else
      clean_up_passwords resource
      return render :json => { :success => false }
    end
  end
  
  def resend_password
    if user = User.where(email: params[:email]).first
      Notifier.resend_password(params[:email], user).deliver
      return render :json => { :success => true }
    else
      return render :json => { :success => false }
    end
  end
    
end 