require 'spec_helper'

describe UserFeedController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  describe 'GET show' do
    it_should_properly_assign_user(by_user_id: true, action: :show, skip_user_always_true: true)

    # it_should_handle_before_and_after_for_action_and_by_current_user(Round, :index)
    
    it 'should be much better specd :D'
  end

  describe 'POST friends' do
    it "should return an error if the ids aren't saved"

    it 'should require provider/uids in params' do
      post :friends, {}, valid_session
      response.status.should == 406

      post :friends, {provider: 'facebook'}, valid_session
      response.status.should == 406

      post :friends, {uids: []}, valid_session
      response.status.should == 406
    end

    it 'should update .friends for current_user' do
      uid, user_id = 4, '5'
      FactoryGirl.create(:authorization, provider: 'facebook', uid: uid, user_id: user_id)
      post :friends, {provider: 'facebook', uids: [1,2,3,uid]}, valid_session
      response.body.should == "[#{user_id}]"
    end

    it 'should assign @user_ids with all ids of friends in the system' do
      @friend_user = FactoryGirl.create(:user)
      @other_user  = FactoryGirl.create(:user)
      FactoryGirl.create(:authorization, provider: 'facebook', user: @friend_user)
      FactoryGirl.create(:authorization, provider: 'facebook', user: @friend_user)
      friend_facebook_uid = @friend_user.authorizations.first.uid

      post :friends, {provider: 'facebook', uids: [friend_facebook_uid]}, valid_session

      assigns(:user_ids).should == [@friend_user.id]
    end
  end
end
