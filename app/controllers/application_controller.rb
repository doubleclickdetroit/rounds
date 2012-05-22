class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user_for_api!

  # before_filter :authenticate if Rails.env.production?

  helper_method :current_user

protected
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "rounds_dev_server" && password == "YE%:Py+,oT\]dPWD"
    end
  end

  def authenticate_user_for_api!
    head :unauthorized if request.path =~ %r{^/api/} && !current_user
  end

private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
