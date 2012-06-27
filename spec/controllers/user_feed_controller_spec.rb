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

    it 'should update .friend_ids for current_user', :focus do
      @friend      = FactoryGirl.create(:user)
      @friend_auth = FactoryGirl.create(:authorization, user_id: @friend.id)
      post :friends, {provider: @friend_auth.provider, uids: [@friend_auth.uid]}, valid_session
      @user.reload.friend_ids.should == [@friend.to_param]
    end

    it 'should return a proper hash' # handled by @user.set_friends
  end
end
