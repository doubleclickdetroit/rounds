require 'spec_helper'

describe RoundLocksController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  it 'should authenticate the user'

  describe 'GET show' do
    it 'should return a given RoundLock' do
      @round_lock = Factory(:round_lock)
      params = { :id => @round_lock.to_param }

      RoundLock.should_receive(:find).with(@round_lock.to_param)
      get :show, params, valid_session
    end
  end

  describe 'POST create' do
    it 'should create a new RoundLock' do
      params = { :round_lock => Factory.build(:round_lock).attributes }

      expect {
        post :create, params, valid_session
      }.to change(RoundLock, :count).by(1)
    end
  end

  describe 'DELETE destroy' do
    it 'should destroy the RoundLock whose id was passed in' do
      @round_lock = Factory(:round_lock)
      params = { :id => @round_lock.to_param }

      expect {
        delete :destroy, params, valid_session
      }.to change(RoundLock, :count).by(-1)
    end
  end

end
