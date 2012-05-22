module ControllerMacros
  def login_user
    before(:each) do
      @user = Factory(:user)
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      session[:user_id] = @user.id
    end
  end
end
