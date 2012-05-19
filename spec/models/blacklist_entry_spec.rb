require 'spec_helper'

describe BlacklistEntry do
  before(:each) do
    @user         = FactoryGirl.create(:user)
    @blocked_user = FactoryGirl.create(:user)
    @blentry      = FactoryGirl.create(:blacklist_entry, :user_id => @user.id, :blocked_user_id => @blocked_user.id)
  end

  # todo this is likely unnecessary...
  it 'should belong to a User' do
    @blentry.user.should be_an_instance_of(User)
  end
end
