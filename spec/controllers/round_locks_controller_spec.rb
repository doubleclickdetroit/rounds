require 'spec_helper'

describe RoundLocksController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  describe 'GET show' do
    before(:each) do
      @round      = FactoryGirl.create(:round)
      @round_lock = FactoryGirl.create(:round_lock, :round_id => @round.id)
      @params     = { :round_id => @round.to_param }
    end

    it 'should return a RoundLock for a given Round' do
      RoundLock.should_receive(:find_by_round_id).with(@round.to_param)
      get :show, @params, valid_session
    end

    it 'should return a PrivatePub subscription for /api/rounds/:round_id/lock ' do
      PrivatePub.should_receive :subscription, {channel: "/api/rounds/#{@round.id}/lock"}
      get :show, @params, valid_session
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
      lock.user_id.should      == @user.id
    end
  end

  describe 'DELETE destroy' do
    it 'should destroy the RoundLock whose id was passed in belonging to the user' do
      @round      = FactoryGirl.create(:round)
      @round_lock = FactoryGirl.create(:round_lock, :user_id => @user.id, :round_id => @round.to_param)
      params = { :round_id => @round.to_param }

      expect {
        delete :destroy, params, valid_session
      }.to change(RoundLock, :count).by(-1)
    end

    it 'should not destroy a round lock not belonging to the user' do
      @round      = FactoryGirl.create(:round)
      @round_lock = FactoryGirl.create(:round_lock, :user_id => FactoryGirl.create(:user).id, :round_id => @round.to_param)
      params = { :round_id => @round.to_param }

      expect {
        delete :destroy, params, valid_session
      }.to change(RoundLock, :count).by(0)
    end
  end

end
