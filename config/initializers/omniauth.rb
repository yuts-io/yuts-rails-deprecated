Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, ENV['GOOG_CLIENT_ID'], ENV['GOOG_CLIENT_SECRET']
end

OmniAuth.config.allowed_request_methods = %i[get]