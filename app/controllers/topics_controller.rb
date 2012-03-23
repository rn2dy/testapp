require 'date'
class TopicsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_topic, except: [:create]

  layout 'fluid', only: [:show]

  def show
    @email_list = { @topic.id => @topic.participants.map { |p| p.email } }
  end

  def create
    @topic = current_user.topics.new params[:topic].merge(starter_name: current_user.name, starter_id: current_user.id)    
    respond_to do |format|
      if @topic.save
        @topic.add_invitees(current_user, params[:invitees]) if params[:invitees].present?        
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
      else
        format.html { redirect_to home_dashboard_url }
      end
    end
  end

  def update 
    respond_to do |format|
      if @topic.update_attributes!(name: params[:topic][:name])
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
      format.js
    end
  end
  
  # add_links.js.erb
  def add_links
    @new_link = @topic.add_links(current_user, params[:url])
    respond_to do |format|
      format.js
    end
  end

  # refresh view in every 30 sec  
  def refresh
    @new_links = @topic.links.check_new(current_user.id, 
      DateTime.strptime(params[:lld], '%Y-%m-%d %H:%M:%S %z'))
    @new_comments = @topic.comments.check_new(current_user.id,
      DateTime.strptime(params[:lcd], '%Y-%m-%d %H:%M:%S %z'))

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
