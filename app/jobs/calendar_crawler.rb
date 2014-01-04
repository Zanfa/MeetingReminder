require 'google/api_client'

class CalendarCrawler

  def initialize(user_id, access_token, refresh_token)
    @user_id = user_id

    @client = Google::APIClient.new(
        application_name: 'test',
        application_version:1.0
    )

    @client.authorization.client_id = ENV['GOOGLE_APP_ID']
    @client.authorization.client_secret = ENV['GOOGLE_APP_SECRET']
    @client.authorization.refresh_token = refresh_token
    @client.authorization.access_token = access_token

    if @client.authorization.refresh_token && @client.authorization.expired?
      @client.authorization.fetch_access_token!
    end

    @service = @client.discovered_api('calendar', 'v3')
  end

  def scrape_calendars
    @temp_calendars = []

    page_token = nil
    result = @client.execute(api_method: @service.calendar_list.list)
    while true

      result.data.items.each do |calendar|
        @temp_calendars << calendar if
            calendar.accessRole == 'owner' || calendar.accessRole == 'writer'
      end

      unless (page_token = result.data.next_page_token)
        break
      end
      result = client.execute(api_method: @service.calendar_list.list,
                              parameters: {pageToken: page_token})
    end

  end

  def scrape_events
    @temp_events = []

    @temp_calendars.each do |calendar|

      page_token = nil
      result = @client.execute(
          api_method: @service.events.list,
          parameters: {
            calendarId: calendar.id
          }
      )
      while true
        result.data.items.each do |events|
          @temp_events << events
        end

        unless (page_token = result.data.next_page_token)
          break
        end

        result = client.execute(
            api_method: @service.events.list,
            parameters: {
                pageToken: page_token,
                calendarId: calendar.id
            })
      end
    end

    @temp_events.each do |event|
      participants = []
      event.attendees.each do |attendee|
        participants << attendee.email
      end

      # Get date instead of datetime if an all-day event
      start_datetime = event.start['dateTime'] ? event.start.dateTime : event.start.date
      end_datetime = event.end['dateTime'] ? event.end.dateTime : event.end.date

      # Ignore past events
      next if start_datetime < Date.today

      Event.create(
          google_id: event.id,
          title: event.summary,
          description: event.description,
          start_time: start_datetime,
          end_time: end_datetime,
          participants: participants,
          user_id: @user_id,
          notify: true,
          notified: false
      )
    end
  end

end