class UserMailer < ActionMailer::Base

  def subscriber_notification(sender, reciever)
    @sender = sender
    @reciever = reciever
    mail(to: reciever.email , from: sender.email, subject: "Subscriber Notification")
  end

  def unsubscriber_notification(sender, reciever)
    @sender = sender
    @reciever = reciever
    mail(to: reciever.email , from: sender.email, subject: "UnSubscriber Notification")
  end


  def subscribe_notification(sender, reciever)
    @sender = sender
    @reciever = reciever
    mail(from: reciever.email , to: sender.email, subject: "Subscribe Notification")
  end

  def unsubscribe_notification(sender, reciever)
    @sender = sender
    @reciever = reciever
    mail(from: reciever.email , to: sender.email, subject: "UnSubscribe Notification")
  end

end