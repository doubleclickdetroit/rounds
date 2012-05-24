require 'spec_helper'

describe RoundsController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  describe 'GET index' do
    it_should_handle_index_by_user(Round)
    it_should_handle_before_and_after_for_action_and_by_current_user(Round, :index)
  end

  describe 'GET show' do
    it 'should return a given Round' do
      @round = FactoryGirl.create(:round)
      params = { :id => @round.to_param }

      Round.should_receive(:find).with(@round.to_param)
      get :show, params, valid_session
    end
  end

  describe 'POST create' do
    it 'should create a new Round' do
      expect {
        post :create, {}, valid_session
      }.to change(Round, :count).by(1)
    end

    it 'should create a new RoundLock for current_user and Round' do
      expect {
        post :create, {}, valid_session
      }.to change(RoundLock, :count).by(1)
      
      RoundLock.last.user_id.should   == @user.id
      RoundLock.last.round.should == Round.last
    end

    it 'should set Round.created_by to current_user' do
      post :create, {} , valid_session
      Round.last.creator.should == @user
    end
  end

  describe 'PUT update' do
    it 'should update the Round whose id was passed in' do
      pending 'dont think this is needed'
      @round = FactoryGirl.create(:round, :user_id => 1)

      id  = @round.to_param
      user_id = 2
      params = { 
        :id => id,
        :round  => {:user_id => user_id} 
      }

      put :update, params, valid_session
      Round.find(id).user_id.should == user_id 
    end
  end

  describe 'DELETE destroy' do
    it 'should destroy the (empty) Round whose id was passed in' do
      @round = FactoryGirl.create(:round)
      params = { :id => @round.to_param }

      expect {
        delete :destroy, params, valid_session
      }.to change(Round, :count).by(-1)
    end

    it 'should not destroy the Round if has any slides' do
      @round = FactoryGirl.create(:round)
      FactoryGirl.create(:slide, :round_id => @round.id)

      params = { :id => @round.to_param }

      expect {
        delete :destroy, params, valid_session
      }.to change(Round, :count).by(0)
    end

    it 'should respond with a ... if the Round if has any slides'
  end

end
