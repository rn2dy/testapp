class TopicsController < ApplicationController
  layout 'fluid', only: [:show]
  
  def index
    @topics = current_user.topics

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @topics }
    end
  end

  def show
    @topic = current_user.topics.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @topic }
    end
  end

  def edit
    @topic = current_user.topics.find(params[:id])
  end

  def create
    @topic = current_user.topics.new params[:topic].merge(starter_name: current_user.name, starter_id: current_user.id)
    @topic.add_invitees(params[:invitees])

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


  def destroy
    @topic = current_user.topics.find(params[:id])
    respond_to do |format|
      if current_user.topics.delete(@topic)
        format.html { redirect_to home_dashboard_path, notice: 'Left the topic...' }
      end
    end
  end

  def add_invitees
    @topic = current_user.topics.find(params[:id])
    @topic.add_invitees(params[:invitees])

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

end
