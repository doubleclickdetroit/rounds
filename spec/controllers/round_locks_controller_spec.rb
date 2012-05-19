require 'spec_helper'

describe RoundLocksController do
  attr_accessor :valid_attributes, :valid_session

  # login_user()

  it 'should authenticate the user'

  describe 'GET show' do
    it 'should return a given RoundLock' do
      @round      = FactoryGirl.create(:round)
      @round_lock = FactoryGirl.create(:round_lock, :round_id => @round.id)
      params = { :round_id => @round.to_param }

      RoundLock.should_receive(:find_by_round_id).with(@round.to_param)
      get :show, params, valid_session
    end
  end

  describe 'POST create' do
    it 'should first check for a RoundLock' do
      @round      = FactoryGirl.create(:round)
      @round_lock = FactoryGirl.create(:round_lock, :round_id => @round.to_param)
      params      = { :round_id => @round.to_param }

      post :create, params, valid_session
      response.status.should == 423
    end

    it 'should create a new RoundLock' do
      @round = FactoryGirl.create(:round)
      params = { :round_id => @round.to_param }

      expect {
        post :create, params, valid_session
      }.to change(RoundLock, :count).by(1)

      lock = RoundLock.last

      lock.round_id.should == @round.id
      lock.fid.should      == @user.id
    end
  end

  describe 'DELETE destroy' do
    it 'should destroy the RoundLock whose id was passed in' do
      @round      = FactoryGirl.create(:round)
      @round_lock = FactoryGirl.create(:round_lock, :round_id => @round.to_param)
      params = { :round_id => @round.to_param }

      expect {
        delete :destroy, params, valid_session
      }.to change(RoundLock, :count).by(-1)
    end
  end

end
