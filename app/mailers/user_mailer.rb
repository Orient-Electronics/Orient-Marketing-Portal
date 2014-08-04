class UserMailer < ActionMailer::Base
  default from: "noreply@orient.pk"
  def subscriber_notification(sender, reciever)
    @sender = sender
    @reciever = reciever
    mail(to: reciever.email , subject: "Subscriber Notification")
  end

  def unsubscriber_notification(sender, reciever)
    @sender = sender
    @reciever = reciever
    mail(to: reciever.email , subject: "UnSubscriber Notification")
  end


  def subscribe_notification(sender, reciever)
    @sender = sender
    @reciever = reciever
    mail(to: sender.email, subject: "Subscribe Notification")
  end

  def unsubscribe_notification(sender, reciever)
    @sender = sender
    @reciever = reciever
    mail(to: sender.email, subject: "UnSubscribe Notification")
  end

  def subscriber_activity(activity, reciever, owner)
    @owner = owner
    @reciever = reciever
    @activity = activity
    mail(to: @reciever.email, from: "noreply@orient.pk",  subject: "Subscriber's Activity")
  end
end