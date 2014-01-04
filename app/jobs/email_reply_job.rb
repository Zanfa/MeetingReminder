class EmailReplyJob
  include SuckerPunch::Job
  workers 10

  def perform(msg)
    NotificationMailer.reply_meeting_notification(msg).deliver
  end
end