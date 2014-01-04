json.array!(@users) do |user|
  json.extract! user, :id, :google_id, :email, :access_token, :refresh_token
  json.url user_url(user, format: :json)
end
