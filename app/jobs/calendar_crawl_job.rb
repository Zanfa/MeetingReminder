class CalendarCrawlJob
  include SuckerPunch::Job
  workers 10

  def perform(msg)
    crawler = CalendarCrawler.new(msg[:id],
                                  msg[:access_token],
                                  msg[:refresh_token])
    crawler.scrape_calendars
    crawler.scrape_events
  end

end