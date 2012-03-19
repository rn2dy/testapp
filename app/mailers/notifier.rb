class Notifier < ActionMailer::Base
  default from: "noreply@klipt.me", cc: "smartplaymonks@gmail.com"
  
  def invited(invitor, invitee, topic)
    @invitor_name = invitor.name
    @invitee_name = invitee.name
    @topic = topic
    mail to: invitee.email, :subject => "Klipt message - You are invited to the topic: #{ topic.name.upcase }!"
  end
  
  def unknown_user_invited(invitor, invitee_email, topic)
    @invitor_name = invitor.name
    @invitee_email = invitee_email
    @topic = topic
    mail to: invitee_email, :subject => "Klipt message - You are invited to the topic: #{ topic.name.upcase }!"
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
