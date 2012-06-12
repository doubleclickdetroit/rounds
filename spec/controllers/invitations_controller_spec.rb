require 'spec_helper'

describe InvitationsController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  before(:each) { Invitation.any_instance.stub(:content).and_return('') }

  describe 'GET index', :focus do
    it_should_handle_index_by_parent_id(Invitation, Round)

    it 'should handle requests with no round_id relative to current_user' do
      get :index, {}, valid_session
      assigns(:user).should == @user
    end

    it_should_handle_before_and_after_for_action_and_by_current_user(Invitation, :index)
  end

  describe 'POST create' do
    describe 'with incorrect params' do
      it 'should throw a 406 if there is no round_id' do
        post :create, {}, valid_session 
        response.status.should == 406
      end

      it 'should throw a 406 if there is no invited_user_id' do
        post :create, { :round_id => FactoryGirl.create(:round).to_param }, valid_session 
        response.status.should == 406
      end

      it 'should handle bad params'
    end

    it 'should create a new Invitation' do
      round   = FactoryGirl.create(:round)
      invited = FactoryGirl.create(:user)

      expect {
        post :create, { :round_id => round.to_param, :invited_user_id => invited.id }, valid_session 
      }.to change(Invitation, :count).by(1)

      Invitation.last.creator.should     == @user
      Invitation.last.invited_user_id.should == invited.id
      Invitation.last.round.should       == round
    end
  end

  describe 'DELETE destroy' do
    it 'should not throw a 406 if there is no invitation_id' do
      pending 'no idea, try after you have more implemented'
      delete :destroy, {}, valid_session 
      response.status.should_not == 406
    end

    it 'should destroy the Invitation whose id was passed in' do
      @invitation = FactoryGirl.create(:invitation)
      params = { :id => @invitation.to_param }

      expect {
        delete :destroy, params, valid_session
      }.to change(Invitation, :count).by(-1)
    end
  end

end
