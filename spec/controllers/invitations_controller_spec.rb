require 'spec_helper'

describe InvitationsController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  before(:each) { Invitation.any_instance.stub(:content).and_return('') }

  it 'should authenticate the user'

  describe 'GET index' do
    it 'should throw a 406 if there is no round_id' do
      get :index, {}, valid_session 
      response.status.should == 406
    end

    it 'should show Invitations for a Round' do
      @round = Factory(:round)
      @invitation = Factory(:invitation, :round_id => @round.id)
      params = { :round_id => @round.to_param }

      get :index, params, valid_session
      assigns(:invitations).should == [@invitation]
    end
  end

  describe 'POST create' do
    describe 'with incorrect params' do
      it 'should throw a 406 if there is no round_id' do
        post :create, {}, valid_session 
        response.status.should == 406
      end

      it 'should throw a 406 if there is no invited_fid' do
        post :create, { :round_id => Factory(:round).to_param }, valid_session 
        response.status.should == 406
      end

      it 'should handle bad params'
    end

    it 'should create a new Invitation' do
      round   = Factory(:round)
      invited = Factory(:user)

      expect {
        post :create, { :round_id => round.to_param, :invited_fid => invited.fid }, valid_session 
      }.to change(Invitation, :count).by(1)

      Invitation.last.creator.should     == @user
      Invitation.last.invited_fid.should == invited.fid
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
      @invitation = Factory(:invitation)
      params = { :id => @invitation.to_param }

      expect {
        delete :destroy, params, valid_session
      }.to change(Invitation, :count).by(-1)
    end
  end

end
