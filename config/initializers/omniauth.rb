Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_KEY"], ENV["GOOGLE_SECRET"], {
      scope: 'userinfo.email, calendar',
      prompt: 'consent',
      access_type: 'offline',
      name: 'google'
  }
end