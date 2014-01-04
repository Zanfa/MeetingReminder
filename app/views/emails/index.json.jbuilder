json.array!(@emails) do |email|
  json.extract! email, :id, :headers, :text, :html, :from, :to, :cc, :subject
  json.url email_url(email, format: :json)
end
