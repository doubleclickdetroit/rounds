require 'spec_helper'

describe WatchingsController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  it 'should authenticate the user'

  pending 'needs to use current_user.fid'

  describe 'POST create' do
    it 'should throw a 406 if there is no round_id' do
      post :create, {}, valid_session
      response.status.should == 406
    end

    it 'should create a new Watching' do
      @round = Factory(:round)
      params = { :round_id => @round.id }

      expect {
        post :create, params, valid_session
      }.to change(Watching, :count).by(1)

      w = Watching.last
      w.round_id.should == @round.id
      w.fid.should      == @user.fid
    end
  end

  # describe 'DELETE destroy' do
  #   it 'should not throw a 406 if there is no round_id' do
  #     pending 'no idea, try after you have more implemented'
  #     delete :destroy, {}, valid_session
  #     response.status.should_not == 406
  #   end

  #   it 'should destroy the Watching whose id was passed in' do
  #     @watching = Factory(:watching)
  #     params = { :id => @watching.to_param }

  #     expect {
  #       delete :destroy, params, valid_session
  #     }.to change(Watching, :count).by(-1)
  #   end
  # end

end
