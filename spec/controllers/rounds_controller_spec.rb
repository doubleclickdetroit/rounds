require 'spec_helper'

describe RoundsController do
  attr_accessor :valid_attributes, :valid_session

  # login_user()

  it 'should authenticate the user'

  describe 'GET index' do
    context 'with no time arg' do
      it 'should show Rounds created by the current_user' do
        3.times { @round = FactoryGirl.create(:round, :user_id => @user.id) }
        4.times { @round = FactoryGirl.create(:round) }

        get :index, {}, valid_session
        assigns(:rounds).count.should == 3

        # brings total by user to 9
        6.times { @round = FactoryGirl.create(:round, :user_id => @user.id) }

        get :index, {}, valid_session
        assigns(:rounds).count.should == 8
      end
    end

    context 'with time arg' do
      it 'should show Rounds created by the current_user' do
        earlier_time = Time.now
        3.times { @round = FactoryGirl.create(:round, :user_id => @user.id, :created_at => earlier_time) }
        time = earlier_time + 3
        4.times { @round = FactoryGirl.create(:round, :user_id => @user.id, :created_at => time) }

        # get Rounds before time
        get :index, {:time => time}, valid_session
        assigns(:rounds).count.should == 3

        # brings total to 9
        6.times { @round = FactoryGirl.create(:round, :user_id => @user.id, :created_at => earlier_time) }

        get :index, {:time => time}, valid_session
        assigns(:rounds).count.should == 8
      end
    end
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
    it 'should destroy the Round whose id was passed in' do
      @round = FactoryGirl.create(:round)
      params = { :id => @round.to_param }

      expect {
        delete :destroy, params, valid_session
      }.to change(Round, :count).by(-1)
    end
  end

end
