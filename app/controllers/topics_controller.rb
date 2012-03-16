class TopicsController < ApplicationController
  layout 'fluid', only: [:show]
  before_filter :find_topic, except: [:create]

  def show
    @email_list = { @topic.id => @topic.participants.map { |p| p.email } }
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @topic }
    end
  end

  def create
    @topic = current_user.topics.new params[:topic].merge(starter_name: current_user.name, starter_id: current_user.id)
    @topic.add_invitees(current_user, params[:invitees]) if params[:invitees].present?
    respond_to do |format|
      if @topic.save        
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
        format.json { render json: @topic, status: :created, location: @topic }
      else
        format.html { render action: "new" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def update 
    respond_to do |format|
      if @topic.update_attributes!(name: params[:topic][:name])
        format.html { redirect_to @topic, notice: 'Topic name succesfully updated!' }
        format.js
      else
        format.html { redirect_to @topic, notice: 'Topic name is not updated!' }
        format.js
      end
    end
  end
  
  def destroy
    respond_to do |format|
      if current_user.topics.delete(@topic)
        format.html { redirect_to home_dashboard_path, notice: 'Left the topic...' }
      end
    end
  end

  def add_invitees
    @topic.add_invitees current_user, params[:invitees]

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'Invitees added!' }
        format.json { render json: @topic, status: :created, location: @topic }
      else
        format.html { render action: "new" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # add_comments.js.erb
  def add_comments
    @comment = @topic.add_comments(current_user, params[:content])
    respond_to do |format|
      format.html { redirect_to @topic, notice: 'New comment added!' }
      format.js
    end
  end
  
  # add_links.js.erb
  def add_links
    @new_link = @topic.links.build url: params[:url], creator_name: current_user.name
    @new_link.user = current_user
    
    respond_to do |format|
      if @new_link.save
        format.html { redirect_to @topic, notice: 'Links added!' }
        format.js
      else
        format.html { redirect_to @topic, notice: 'Link not added!' }
        format.js
      end
    end
  end
  
  def refresh
    @links = @topic.links.recent
    @comments = @topic.comments.recent
    respond_to do |format|
      format.js      
    end
  end
  
  private 
  
  def find_topic
    @topic ||= current_user.topics.find(params[:id])
  end

end
