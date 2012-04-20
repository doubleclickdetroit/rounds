module ControllerMacros
  def login_user
    before(:each) do
      @user  = Factory(:user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      # request.env['warden'] = mock(Warden, :authenticate => mock_user, :authenticate! => mock_user)
      sign_in @user 
    end
  end
end
