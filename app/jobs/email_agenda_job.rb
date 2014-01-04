class EmailAgendaJob
  include SuckerPunch::Job
  workers 10

  def perform

    ActiveRecord::Base.connection_pool.with_connection do

      User.all.each do |user|
        events = user.events.order(start_time: :asc).where(
            start_time: Date.today.beginning_of_day..Date.today.end_of_day
        )

        NotificationMailer.agenda(user.email, events).deliver

      end

    end

  end

end