class BookmarkletController < ApplicationController
  before_filter :authenticate, except: [:index, :login]
  layout false

  # sign in page
  def index
    @user = User.new
  end

  def login
    redirect_to root_path
  end

  def new_link
  end

  def add_link
  end


  def new_topic
  end

  def add_new_topic
  end

  private

  def authenticate
    unless user_signed_in? 
      redirect_to bookmarklet_index_path
    end
  end
end
