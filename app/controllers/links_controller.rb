class LinksController < ApplicationController
  respond_to :json

  def create
    @topic = Topic.find(params[:topic_id])
    @link = @topic.links.build(params[:link].merge(creator_name: current_user.name))
    @link.user = current_user
    
    if @link.save!
      respond_with @link, { id: @link.id }
    else
      respond_with @link.errors, status: :unprocessable_entity
    end
  end

  def destroy 
    @link = Link.find(params[:id])
    @link.delete
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def add_notes 
  end

end
