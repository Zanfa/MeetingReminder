class EmailNotificationJob
  include SuckerPunch::Job
  workers 10

  def perform(opts={})

    NotificationMailer.meeting_notification(opts).deliver
  end

end