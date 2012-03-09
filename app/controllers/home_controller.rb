class HomeController < ApplicationController
  def index
  end

  def dashboard
    @topics = current_user.topics        
    @topic = Topic.new
  end
end
