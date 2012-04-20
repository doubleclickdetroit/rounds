require 'spec_helper'

describe RoundsController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  it 'should authenticate the user'

  describe 'GET index' do
    it 'should throw a 406 if there is no group_id' do
      pending 'creation of groups'
      get :index, {}, valid_session 
      response.status.should == 406
    end

    it 'should show Rounds for a Group' do
      pending 'creation of groups'
      @group = Factory(:group)
      @round = Factory(:round)
      @group.rounds << @round
      params = { :group_id => @group.to_param }

      get :index, params, valid_session
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
    it 'should throw a 406 if there is no group_id' do
      pending 'creation of groups'
      post :create, {}, valid_session 
      response.status.should == 406
    end

    it 'should create a new Round' do
      pending 'creation of groups'
      @group = Factory(:group)
      params = { :group_id => @group.to_param, :round => {} }

      expect {
        post :create, params, valid_session
      }.to change(Round, :count).by(1)
    end
  end

  describe 'PUT update' do
    it 'should not throw a 406 if there is no slide_id' do
      pending 'no idea, try after you have more implemented'
      put :update, { :round => Factory.build(:round) }, valid_session 
      response.status.should_not == 406
    end

    it 'should update the Round whose id was passed in' do
      pending 'creation of groups'
      @round = Factory(:round)

      id = @round.to_param
      group_id = 1 
      params = { 
        :id => id,
        :round  => {:group_id => group_id} 
      }

      put :update, params, valid_session
      Round.find(id).group_id.should == group_id 
    end
  end

  describe 'DELETE destroy' do
    it 'should not throw a 406 if there is no slide_id' do
      pending 'no idea, try after you have more implemented'
      delete :destroy, {}, valid_session 
      response.status.should_not == 406
    end

    it 'should destroy the Round whose id was passed in' do
      @round = Factory(:round)
      params = { :id => @round.to_param }

      expect {
        delete :destroy, params, valid_session
      }.to change(Round, :count).by(-1)
    end
  end

end
