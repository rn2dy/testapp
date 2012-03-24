class SessionsController < Devise::SessionsController
  def new
    redirect_to root_url 
  end
  
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    return sign_in_and_redirect(resource_name, resource)
  end
    
  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource    
    return render :json => { :success => true, :redirect => ( from_site? ? after_sign_in_path_for(resource) : stored_location_for(scope) ) }    
  end

  def failure      
    return render :json => { :success => false }
  end
  
  def from_site?
    params[:src].present? && params[:src] == 'site'    
  end

end
