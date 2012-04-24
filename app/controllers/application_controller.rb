class ApplicationController < ActionController::Base
  before_filter :authenticate

  protect_from_forgery

protected
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "rounds_dev_server" && password == "YE%:Py+,oT\]dPWD"
    end
  end
end
