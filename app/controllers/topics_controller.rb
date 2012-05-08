require 'date'
class TopicsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_topic, except: [:create]

  layout 'fluid', only: [:show]

  def show
    @hide_notify = true if params[:notifications] == "off" 

    @email_list = { @topic.id => @topic.participants.map { |p| p.email } }
  end

  def create
    @topic = current_user.topics.new params[:topic].merge(starter_name: current_user.name, starter_id: current_user.id)    
    respond_to do |format|
      if @topic.save
        @topic.add_invitees(current_user, params[:invitees]) if params[:invitees].present?        
        format.html { redirect_to @topic }
        format.json { render json: { success: true, redirect: topic_path(@topic) } } 
      else
        format.html { redirect_to home_dashboard_url }
        format.json { render json: { success: false, errors: "Same topic already exist!" } }
      end
    end
  end

  def update 
    respond_to do |format|
      if @topic.update_attributes!(name: params[:topic][:name])
        #format.js
        format.html { redirect_to topic_path @topic }
      end
    end
  end
  
  def destroy
    respond_to do |format|
      if current_user.topics.delete(@topic)
        if @topic.participants.empty?
          @topic.delete
        end
        format.html { redirect_to home_dashboard_path }
      end
    end
  end

  def add_invitees
    @topic.add_invitees current_user, params[:invitees]

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic }
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
    @links = @topic.links.recent
    @comments = @topic.comments.recent
    respond_to do |format|
      format.js      
    end
  end

  private 
  
  def find_topic
    @topic ||= current_user.topics.find_by_slug params[:id]
  end

end
