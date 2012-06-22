require 'spec_helper'

describe SessionsController do
  pending 'spec token'
  pending 'spec friend ids'

  # watchings
  # unread invitations
  # gamification
  #   points/currency
  #   rank
  # user abilities
  # message of the day type messages

  describe 'GET create' do
    context 'provider success' do
      it 'should create a new User if one does not exist' do
        User.count.should == 0

        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :create, {}, {}

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
        get :create, {}, {}

        assigns(:user).should == @user

        User.count.should == 1
        Authorization.count.should == 1
      end

      it 'should set the user_id in session' do
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]

        get :create, {}, {}

        session[:user_id].should_not be_nil
      end

      context 'instance vars for return' do
        before(:each) do
          @provider = OmniAuth.config.mock_auth[:facebook][:provider]
          @uid      = OmniAuth.config.mock_auth[:facebook][:uid]
          @user     = FactoryGirl.create :user
          @auth     = FactoryGirl.create :authorization, provider: @provider, uid: @uid
          @user.authorizations << @auth

          # noise
          FactoryGirl.create(:watching)
          FactoryGirl.create(:invitation)
          FactoryGirl.create(:invitation, read: true, invited_user_id: @user.id)

          # creating records to be found
          FactoryGirl.create(:watching, user: @user)
          FactoryGirl.create(:invitation, read: false, invited_user_id: @user.id)
        end

        it 'should assign count of user Watchings to @watchings_count' do
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
          get :create, {}, {}

          assigns(:watchings_count).should == 1
        end

        it 'should assign count of unread user Invitation to @unread_invitations_count' do
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
          get :create, {}, {}

          assigns(:unread_invitations_count).should == 1
        end

        it 'should assign user gamification'
        it 'should assign user abilities'
        it 'should assign system messages'
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
      get :create, {}, {}
      session[:user_id].should_not be_nil

      # destroy it!
      delete :destroy, {}, {}
      session[:user_id].should be_nil
    end
  end
end
