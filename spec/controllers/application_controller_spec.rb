require 'spec_helper'

describe ApplicationController do
  it 'should authenticate a user for api access'
  it 'should not authenticate a user for non-api access'

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
      pending 'in rabl'
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      get :index, {}, {}

      assigns(:watchings_count).should == 1
    end

    it 'should assign count of unread user Invitation to @unread_invitations_count' do
      pending 'in rabl'
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      get :index, {}, {}

      assigns(:unread_invitations_count).should == 1
    end

    it 'should assign user gamification'
    it 'should assign user abilities'
    it 'should assign system messages'
  end
end
