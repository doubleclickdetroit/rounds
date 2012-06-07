require 'spec_helper'

describe RoundsController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  describe 'GET index' do
    it_should_properly_assign_user(action: :index, by_user_id: true)

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
    it 'should throw a 406 if there is no slide_limit' do
      post :create, {}, valid_session 
      response.status.should== 406
    end

    it 'should create a new Round' do
      expect {
        post :create, {slide_limit: 7}, valid_session
      }.to change(Round, :count).by(1)
    end

    it 'should create a new RoundLock for current_user and Round' do
      expect {
        post :create, {slide_limit: 7}, valid_session
      }.to change(RoundLock, :count).by(1)
      
      RoundLock.last.user_id.should == @user.id
      RoundLock.last.round.should   == Round.last
    end

    it 'should set Round.created_by to current_user' do
      post :create, {slide_limit: 7} , valid_session
      Round.last.creator.should == @user
    end

    it 'should set Round.slide_limit by params' do
      slide_limit = 7
      post :create, {slide_limit: slide_limit} , valid_session
      Round.last.slide_limit.should == 7
    end

    describe 'private' do
      it 'should be set set to false if not in params' do
        post :create, {slide_limit: 7} , valid_session
        Round.last.private.should be_false
      end

      it 'should be set set to true if in params' do
        post :create, {slide_limit: 7, :private => true} , valid_session
        Round.last.private.should be_true
      end
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
