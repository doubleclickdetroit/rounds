require 'spec_helper'

describe UserFeedController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  describe 'GET feed' do
    it_should_properly_assign_user(by_user_id: true, action: :feed)

    # it_should_handle_before_and_after_for_action_and_by_current_user(Round, :index)
  end

end
