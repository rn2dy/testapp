class BookmarkletController < ApplicationController
  skip_before_filter :verify_authenticity_token
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
    @new_link = @topic.add_links current_user, params[:url], params[:title], "" 
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
    if params[:plugin] ## plugin access only 
      if user_signed_in?
        render json: { logged_in: true, 
                       topics: current_user.topics.map { |topic| [topic.name, topic.id] } }
      else
        render json: { logged_in: false } 
      end
    else
      unless user_signed_in? 
        redirect_to bookmarklet_index_path
      end
    end
  end
end
