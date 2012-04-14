require 'spec_helper'

describe RoundsController do
  describe 'GET index' do
    it 'should throw a 406 if there is no group_id' do
      pending 'creation of groups'
      get :index, {}, {} 
      response.status.should == 406
    end

    it 'should show Rounds for a Group' do
      pending 'creation of groups'
      @group = Factory(:group)
      @round = Factory(:round)
      @group.rounds << @round
      params = { :group_id => @group.to_param }

      get :index, params, {}
      assigns(:rounds).should == [@round]
    end
  end

  describe 'POST create' do
    it 'should throw a 406 if there is no group_id' do
      pending 'creation of groups'
      post :create, {}, {} 
      response.status.should == 406
    end

    it 'should create a new Round' do
      pending 'creation of groups'
      @group = Factory(:group)
      params = { :group_id => @group.to_param, :round => {} }

      expect {
        post :create, params, {}
      }.to change(Round, :count).by(1)
    end
  end

  describe 'PUT update' do
    it 'should not throw a 406 if there is no slide_id' do
      pending 'no idea, try after you have more implemented'
      put :update, { :round => Factory.build(:round) }, {} 
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

      put :update, params, {}
      Round.find(id).group_id.should == group_id 
    end
  end

  describe 'DELETE destroy' do
    it 'should not throw a 406 if there is no slide_id' do
      pending 'no idea, try after you have more implemented'
      delete :destroy, {}, {} 
      response.status.should_not == 406
    end

    it 'should destroy the Round whose id was passed in' do
      @round = Factory(:round)
      params = { :id => @round.to_param }

      expect {
        delete :destroy, params, {}
      }.to change(Round, :count).by(-1)
    end
  end

end
