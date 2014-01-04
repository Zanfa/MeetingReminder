json.array!(@events) do |event|
  json.extract! event, :id, :title, :description, :participants, :start_time, :end_time, :user_id, :google_id
  json.url event_url(event, format: :json)
end
