# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Meetings::Application.load_tasks

task send_agenda: :environment do
  puts 'Sending out daily Agenda emails...'
  EmailAgendaJob.new.perform()
  puts 'Agendas sent!'
end

task send_notifications: :environment do
  puts 'Sending out meeting notification emails...'
  events = Event.where(
      start_time: DateTime.now..DateTime.now + 1.day,
      notified: false,
      notify: true
  )

  events.each do |event|

    event.participants.each do |participant|
      EmailNotificationJob.new.async.perform(
          to: participant,
          reply_to: "meeting_#{event[:google_id]}@photato.co",
          from: event.user.email,
          subject: event.title
      )
    end
  end

  events.update_all(notified: true)
  puts 'Notifications sent!'
end