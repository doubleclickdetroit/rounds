class ApplicationController < ActionController::Base
  protect_from_forgery

  # before_filter :authenticate if Rails.env.production?

protected
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "rounds_dev_server" && password == "YE%:Py+,oT\]dPWD"
    end
  end
end
