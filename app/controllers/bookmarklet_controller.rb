class BookmarkletController < ApplicationController
  before_filter :authenticate, except: [:index, :login]
  layout false

  # sign in page
  def index
  end

  def login
    redirect_to root_path
  end

  def new_link
    @user = current_user
    @topics = current_user.topics
    @target_url = params[:url]
    @target_title = params[:title]    
  end

  def add_link
    @topic = Topic.find params[:topic]
    @new_link = @topic.add_links current_user, params[:url], params[:title], params[:note]
    head :ok
  end


  def new_topic
    @user = current_user
    @target_url = params[:url]
    @target_title = params[:title]    
  end

  def add_topic
    @topic = current_user.topics.new name: params[:name], starter_name: current_user.name, starter_id: current_user.id
    if @topic.save
      @topic.add_invitees(current_user, params[:invitees]) if params[:invitees].present?
      @topic.add_links current_user, params[:url], params[:title]      
    end    
    head :ok
  end

  private

  def authenticate
    unless user_signed_in? 
      redirect_to bookmarklet_index_path
    end
  end
end
