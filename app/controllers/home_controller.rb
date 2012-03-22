class HomeController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  
  def index
  end
  
  def about
  end
  
  def dashboard
    @topics = current_user.topics
    if @topics
      @email_list = @topics.inject({}) do |h, topic|
        h[topic.id] = topic.participants.map { |p| p.email }
        h
      end
    end       
  end
  
  def sys_notify
    @user = current_user
    @user.notifications.where(:created_at.lt => 1.hour.ago).delete
    render json: @user.notifications
  end
  
end
