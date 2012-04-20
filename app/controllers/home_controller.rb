class HomeController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  
  def index
  end
  
  def about
  end

  def bookmarklet
    @bookmarklet_js = <<HERE 
javascript:(function(){
  f = 'http://www.klipt.me/bookmarklet/new_link?url=' + encodeURIComponent(window.location.href) + 
      '&title=' + encodeURIComponent(document.title);
  a = function(){
    if(!window.open(f,'_klipt_bookmarklet','location=yes,links=no,scrollbars=yes,toolbar=no,width=600,height=400'))
        location.href=f+'jump=yes'
      };
      if(/Firefox/.test(navigator.userAgent)){
        setTimeout(a,0)
      } else { 
        a() 
      }
})();
HERE
  @bookmarklet_js.squish!
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
  
  def sys_notify
    @user = current_user
    @user.notifications.where(:created_at.lt => 1.hour.ago).delete
    render json: @user.notifications
  end

  def cancel_notifications
    current_user.notifications.where(:created_at.lt => Time.now).delete
    head :ok
  end
  
end
