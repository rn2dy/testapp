class HomeController < ApplicationController
  layout "fluid", only: [:dashboard]

  def index
    
  end

  def dashboard
    @owned_topics = current_user.owned_topics        
    @shared_topics = current_user.shared_topics
    @topic = Topic.new
  end
end
