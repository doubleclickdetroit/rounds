require 'spec_helper'

describe BallotsController do

  attr_accessor :valid_attributes, :valid_session

  login_user()

  describe 'GET index' do
    it_should_properly_assign_user(action: :index, by_user_id: true)

    it_should_handle_before_and_after_for_action_and_by_current_user(Ballot, :index)
  end

  describe 'POST create' do
    it 'should throw a 406 if there is no :vote'
    it 'should throw a 406 if there is no slide_id' do
      post :create, {}, valid_session
      response.status.should == 406
    end

    it 'should create a new Ballot' do
      @slide = FactoryGirl.create(:slide)
      params = { :slide_id => @slide.to_param, :vote => 3 }

      expect {
        post :create, params, valid_session
      }.to change(Ballot, :count).by(1)
    end
  end

  describe 'GET index' do
    it_should_properly_assign_user(action: :index, by_user_id: true)

    it_should_handle_index_by_parent_id(FactoryGirl.build(:ballot), Slide)
    it_should_handle_before_and_after_for_action_and_by_current_user(Ballot, :index)
  end

end
