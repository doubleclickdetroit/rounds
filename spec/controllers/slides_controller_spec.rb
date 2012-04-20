require 'spec_helper'

describe SlidesController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  before(:each) { Slide.any_instance.stub(:content).and_return('') }

  it 'should authenticate the user'

  describe 'GET index' do
    it 'should throw a 406 if there is no round_id' do
      get :index, {}, valid_session 
      response.status.should == 406
    end

    it 'should show Slides for a Round' do
      @round = Factory(:round)
      @slide = Factory(:slide)
      @round.slides << @slide
      params = { :round_id => @round.to_param }

      get :index, params, valid_session
      assigns(:slides).should == [@slide]
    end
  end

  describe 'GET show' do
    it 'should return a given Slide' do
      @slide = Factory(:slide)
      params = { :id => @slide.to_param }

      Slide.should_receive(:find).with(@slide.to_param)
      get :show, params, valid_session
    end
  end

  describe 'GET show' do
    it 'should not throw a 406 if there is no slide_id' do
      pending 'no idea, try after you have more implemented'
      put :update, { :slide => Factory.build(:slide) }, valid_session 
      response.status.should_not == 406
    end

    it 'should show Slides for a Round' do
      pending 'need for a show action'
      @round = Factory(:round)
      @slide = Factory(:slide)
      @round.slides << @slide
      params = { :round_id => @round.to_param }

      get :show, params, valid_session
      assigns(:slides).should == [@slide]
    end
  end

  describe 'POST create' do
    it 'should throw a 406 if there is no round_id' do
      post :create, {}, valid_session 
      response.status.should == 406
    end

    it 'should create a new Slide' do
      @round = Factory(:round)
      params = { :round_id => @round.to_param, :slide => {} }

      expect {
        post :create, params, valid_session
      }.to change(Slide, :count).by(1)
    end
  end

  describe 'PUT update' do
    it 'should not throw a 406 if there is no slide_id' do
      pending 'no idea, try after you have more implemented'
      put :update, { :slide => Factory.build(:slide) }, valid_session 
      response.status.should_not == 406
    end

    it 'should update the Slide whose id was passed in' do
      @slide = Factory(:slide)

      id = @slide.to_param
      round_id = 1 
      params = { 
        :id => id,
        :slide  => {:round_id => round_id} 
      }

      put :update, params, valid_session
      Slide.find(id).round_id.should == round_id 
    end
  end

  describe 'DELETE destroy' do
    it 'should not throw a 406 if there is no slide_id' do
      pending 'no idea, try after you have more implemented'
      delete :destroy, {}, valid_session 
      response.status.should_not == 406
    end

    it 'should destroy the Slide whose id was passed in' do
      @slide = Factory(:slide)
      params = { :id => @slide.to_param }

      expect {
        delete :destroy, params, valid_session
      }.to change(Slide, :count).by(-1)
    end
  end

end
