class Notifier < ActionMailer::Base
  default from: "smartplaymonks@gmail.com"
  
  def invited(topic, user)
    @topic = topic
    @user = user
    mail to: user.email, :subject => "Klipt message - You are invited to the topic: #{ @topic.name.upcase }!"
  end

  def resend_password(email, user)
    @user = user
    mail to: email, :subject => "Klipt message - Your password."
  end
  
  def registered(email)
    @user_name = email 
    mail to: email, :subject => "Thank you for using Klipt! Wondering what to do next?"
  end
  
end
