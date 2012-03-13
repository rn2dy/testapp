class HomeController < ApplicationController
  def index
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
end
