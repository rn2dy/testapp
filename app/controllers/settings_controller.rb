class SettingsController < ApplicationController
  def edit
  end
  
  def update
    @user = User.find(current_user.id)
    attrs = params[:user]
    name = attrs[:name]
    email = attrs[:email]
    password = attrs[:password]
    password_conf = attrs[:password_confirmation]
    if password.empty?
      attrs = {name: name, email: email}
    else
      attrs = {name: name, email: email, password: password, password_confirmation: password_conf }
    end
    if @user.update_attributes(attrs)
      sign_in @user, bypass: true
      redirect_to home_dashboard_path
    else
      render "edit"
    end
  end
  
end
