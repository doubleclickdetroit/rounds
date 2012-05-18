class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  # before_filter :authenticate if Rails.env.production?

protected
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "rounds_dev_server" && password == "YE%:Py+,oT\]dPWD"
    end
  end

private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
