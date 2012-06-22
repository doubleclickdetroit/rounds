require 'spec_helper'

describe SessionsController do
  pending "this really needs spec'd"

  pending 'spec token'
  pending 'spec friend ids'

  describe 'POST create' do
    context 'provider success' do
      it 'should create a new User if one does not exist' do
        User.count.should == 0

        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        post :create, {}, {}

        User.count.should == 1
      end

      it 'should log the User back in if previously authenticated' do
        provider = OmniAuth.config.mock_auth[:facebook][:provider]
        uid      = OmniAuth.config.mock_auth[:facebook][:uid]

        @user = FactoryGirl.create :user
        @auth = FactoryGirl.create :authorization, provider: provider, uid: uid
        @user.authorizations << @auth

        User.count.should == 1
        Authorization.count.should == 1

        User.via_auth(OmniAuth.config.mock_auth[:facebook]).should == @user

        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        post :create, {}, {}

        assigns(:user).should == @user

        User.count.should == 1
        Authorization.count.should == 1
      end

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
