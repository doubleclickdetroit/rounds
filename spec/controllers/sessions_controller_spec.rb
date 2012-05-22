require 'spec_helper'

describe SessionsController do
  pending "this really needs spec'd"

  describe 'POST create' do
    before(:each) do
      # Authorization.Factory(:provider)
    end

    context 'provider success' do
      it 'should set the user_id in session' do
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]

        post :create, {}, {}

        session[:user_id].should_not be_nil
      end
    end

    context 'provider failure' do
      pending
    end
  end

  describe 'DELETE destroy' do
    it 'should set the user_id in session to nil' do
      # set session
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      post :create, {}, {}
      session[:user_id].should_not be_nil

      # destroy it!
      delete :destroy, {}, {}
      session[:user_id].should be_nil
    end
  end
end
