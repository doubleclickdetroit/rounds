require 'spec_helper'

describe BlacklistEntry do
  before(:each) do
    @user         = Factory(:user)
    @blocked_user = Factory(:user)
    @blentry      = Factory(:blacklist_entry, :user_fid => @user.fid, :blocked_fid => @blocked_user.fid)
  end

  # todo this is likely unnecessary...
  it 'should belong to a User' do
    @blentry.user.should be_an_instance_of(User)
  end
end
