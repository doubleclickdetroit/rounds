require 'spec_helper'

describe BallotsController do

  attr_accessor :valid_attributes, :valid_session

  login_user()

  it 'should authenticate the user'

  describe 'POST create' do
    it 'should throw a 406 if there is no :vote'
    it 'should throw a 406 if there is no slide_id' do
      post :create, {}, valid_session
      response.status.should == 406
    end

    it 'should create a new Ballot' do
      @slide = Factory(:slide)
      params = { :slide_id => @slide.to_param, :vote => 3 }

      expect {
        post :create, params, valid_session
      }.to change(Ballot, :count).by(1)
    end
  end

end
