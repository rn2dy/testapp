class LinksController < ApplicationController
  respond_to :json

  def create
    @topic = Topic.find(params[:topic_id])
    @link = @topic.links.build(params[:link].merge(creator_name: current_user.name))
    @link.user = current_user
    
    if @link.save!
      respond_with @link
    else
      respond_with @link.errors, status: :unprocessable_entity
    end
  end

  def delete
  end

  def update
  end
end
