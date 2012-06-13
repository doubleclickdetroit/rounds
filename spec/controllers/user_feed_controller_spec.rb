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
    it 'should update .friends for current_user'
  end
end
