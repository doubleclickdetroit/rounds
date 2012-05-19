require 'spec_helper'

describe BlacklistEntriesController do
  attr_accessor :valid_attributes, :valid_session

  # login_user()

  it 'should authenticate the user'

  describe "POST 'create'" do
    it 'should throw a 406 if there is no round_id' do
      post :create, {}, valid_session 
      response.status.should == 406
    end

    it "should create a BlacklistEntry" do
      expect {
        post 'create', {:user_user_id => 1, :blocked_user_id => 2}, valid_session 
      }.to change(BlacklistEntry, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do
    it 'should throw a 406 if there is no round_id' do
      delete :destroy, {}, valid_session 
      response.status.should == 406
    end

    it "should destroy a BlacklistEntry" do
      pending 'stupid SQL error'
      FactoryGirl.create(:blacklist_entry, :user_user_id => 1, :blocked_user_id => 2)
      expect {
        delete :destroy, {:user_user_id => 1, :blocked_user_id => 2}, valid_session 
      }.to change(BlacklistEntry, :count).by(-1)
    end
  end

end
