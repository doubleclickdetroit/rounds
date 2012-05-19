module ControllerMacros
  def login_user
    before(:each) do
      @user = Factory(:user)
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      # get '/auth/facebook/callback'
      session[:user_id] = @user.id
      # sign_in @user 
    end
  end
end
