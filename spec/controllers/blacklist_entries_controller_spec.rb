require 'spec_helper'

describe BlacklistEntriesController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  before(:each) do
    @blocked_user = Factory(:user)
  end

  describe "POST 'create'" do

    it 'should throw a 406 if there is no equivalent to blocked_user_id' do
      post :create, {}, valid_session 
      response.status.should == 406
    end

    context 'blocking by user_id' do
      it "should create a BlacklistEntry" do
        expect {
          post 'create', {:blocked_user_id => @blocked_user.id}, valid_session 
        }.to change(BlacklistEntry, :count).by(1)
      end
    end

    context 'blocking by provider/uid' do
      it "should create a BlacklistEntry" do
        auth = FactoryGirl.create(:authorization, :user_id => @blocked_user.id)
        expect {
          post 'create', {:provider => auth.provider, :blocked_uid => auth.uid}, valid_session 
        }.to change(BlacklistEntry, :count).by(1)
      end
    end
  end

  describe "DELETE 'destroy'" do

    it 'should throw a 406 if there is no round_id' do
      delete :destroy, {}, valid_session 
      response.status.should == 406
    end

    context 'unblocking by user_id' do
      it "should destroy a BlacklistEntry" do
        blocked_user_id = @blocked_user.id
        FactoryGirl.create(:blacklist_entry, :user_id => @user.id, :blocked_user_id => blocked_user_id)
        expect {
          delete :destroy, {:blocked_user_id => blocked_user_id}, valid_session 
        }.to change(BlacklistEntry, :count).by(-1)
      end
    end

    context 'unblocking by provider/uid' do
      it "should destroy a BlacklistEntry" do
        auth = FactoryGirl.create(:authorization, :user_id => @blocked_user.id)
        FactoryGirl.create(:blacklist_entry, :user_id => @user.id, :blocked_user_id => @blocked_user.id)

        expect {
          delete :destroy, {:provider => auth.provider, :blocked_uid => auth.uid}, valid_session 
        }.to change(BlacklistEntry, :count).by(-1)
      end
    end
  end

end
