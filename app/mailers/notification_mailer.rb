class NotificationMailer < ActionMailer::Base

  def meeting_notification(opts)

    mail(subject: opts[:subject],
         to: opts[:to],
         from: opts[:from],
         sender: opts[:reply_to],
         reply_to: opts[:reply_to])

  end

  def reply_meeting_notification(opts)

    mail(
        to: opts[:to],
        from: opts[:from],
        sender: opts[:reply_to],
        reply_to: opts[:reply_to],
        subject: opts[:subject]) do |format|

      format.html { opts[:html] } if opts[:html]
      format.text { opts[:text] }
    end

  end

  def agenda(to, events)
    @events = events

    mail(
        to: to,
        from: 'agenda@photato.co',
        subject: 'Your upcoming meetings'
    )

  end
end
