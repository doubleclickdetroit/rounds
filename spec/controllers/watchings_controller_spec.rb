require 'spec_helper'

describe WatchingsController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  describe 'GET index' do
    it 'should use current_user' do
      get :index, {}, valid_session
      assigns(:user).should == @user
    end

    it_should_handle_before_and_after_for_action_and_by_current_user(Watching, :index) 

    it 'should respond with a PrivatePub JSON object for .sign' do
      PrivatePub.should_receive(:subscription)
      FactoryGirl.create :watching, user: @user
      get :index, {}, valid_session
    end

    it 'should assign Dibs if type: dibs' do
      FactoryGirl.create :watching, user: @user
      FactoryGirl.create :dib, user: @user

      get :index, {type: 'Dib'}, valid_session

      assigns(:watchings).count.should == 1
      assigns(:watchings).first.class.should == Dib
    end
  end

  describe 'POST create' do
    pending 'needs to use current_user.id'

    it 'should throw a 406 if there is no round_id' do
      post :create, {}, valid_session
      response.status.should == 406
    end

    it 'should create a new Watching' do
      @round = FactoryGirl.create(:round)
      params = { :round_id => @round.id }

      expect {
        post :create, params, valid_session
      }.to change(Watching, :count).by(1)

      w = Watching.last
      w.round_id.should == @round.id
      w.user_id.should  == @user.id
    end

    it 'should respond with a PrivatePub JSON object for .sign' do
      PrivatePub.should_receive(:subscription)
      round = FactoryGirl.create(:round)
      post :create, {round_id: round.to_param}, valid_session
    end
	end

  describe 'DELETE destroy' do
    it 'should not throw a 406 if there is no round_id' do
      pending 'no idea, try after you have more implemented'
      delete :destroy, {}, valid_session
      response.status.should_not == 406
    end

    it 'should destroy the Watching whose id was passed in' do
      @watching = FactoryGirl.create(:watching)
      params = { :id => @watching.to_param }

      expect {
        delete :destroy, params, valid_session
      }.to change(Watching, :count).by(-1)
    end

    it 'should not respond with a PrivatePub JSON object for .sign' do
      PrivatePub.should_not_receive(:subscription)
      watching = FactoryGirl.create(:watching)
      delete :destroy, {id: watching.to_param}, valid_session
    end
  end

end
