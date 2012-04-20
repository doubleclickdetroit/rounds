require 'spec_helper'

describe RoundsController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  it 'should authenticate the user'

  describe 'GET index' do
    it 'should show Rounds for ...' do
      pending 'for user? do we even need this?'
      @round = Factory(:round)

      get :index, {}, valid_session
      assigns(:rounds).should == [@round]
    end
  end

  describe 'GET show' do
    it 'should return a given Round' do
      @round = Factory(:round)
      params = { :id => @round.to_param }

      Round.should_receive(:find).with(@round.to_param)
      get :show, params, valid_session
    end
  end

  describe 'POST create' do
    it 'should create a new Round' do
      params = { :round => {} }

      expect {
        post :create, params, valid_session
      }.to change(Round, :count).by(1)
    end
  end

  describe 'PUT update' do
    it 'should update the Round whose id was passed in' do
      @round = Factory(:round, :fid => 1)

      id  = @round.to_param
      fid = 2
      params = { 
        :id => id,
        :round  => {:fid => fid} 
      }

      put :update, params, valid_session
      Round.find(id).fid.should == fid 
    end
  end

  describe 'DELETE destroy' do
    it 'should destroy the Round whose id was passed in' do
      @round = Factory(:round)
      params = { :id => @round.to_param }

      expect {
        delete :destroy, params, valid_session
      }.to change(Round, :count).by(-1)
    end
  end

end
