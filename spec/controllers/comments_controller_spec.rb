require 'spec_helper'

describe CommentsController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  describe 'GET index' do
    context 'with slide_id' do
      it 'should show Comments for a Slide' do
        @slide = FactoryGirl.create(:slide)
        @comment = FactoryGirl.create(:comment, :slide_id => @slide.id)
        FactoryGirl.create(:comment, :slide_id => @slide.id + 1)
        params = { :slide_id => @slide.to_param }

        get :index, params, valid_session
        assigns(:comments).should == [@comment]
      end
    end

    context 'without slide_id' do
      context 'and without time arg' do
        it 'should show recent Comments' do
          3.times { @comment = FactoryGirl.create(:comment, :user_id => @user.id) }
          4.times { @comment = FactoryGirl.create(:comment) }

          get :index, {}, valid_session
          assigns(:comments).count.should == 3

          # brings total by user to 9
          6.times { @comment = FactoryGirl.create(:comment, :user_id => @user.id) }

          get :index, {}, valid_session
          assigns(:comments).count.should == 8
        end
      end

      context 'with time arg' do
        it 'should show Slides created by the current_user' do
          earlier_time = Time.now
          3.times { @comment = FactoryGirl.create(:comment, :user_id => @user.id, :created_at => earlier_time) }
          time = earlier_time + 3
          4.times { @comment = FactoryGirl.create(:comment, :user_id => @user.id, :created_at => time) }

          # get comments before time
          get :index, {:time => time}, valid_session
          assigns(:comments).count.should == 3

          # brings total to 9
          6.times { @comment = FactoryGirl.create(:comment, :user_id => @user.id, :created_at => earlier_time) }

          get :index, {:time => time}, valid_session
          assigns(:comments).count.should == 8
        end
      end
    end
  end

  describe 'POST create' do
    it 'should throw a 406 if there is no slide_id' do
      post :create, {}, valid_session
      response.status.should == 406
    end

    it 'should create a new Comment' do
      @slide = FactoryGirl.create(:slide)
      params = { :slide_id => @slide.to_param, :comment => {} }

      expect {
        post :create, params, valid_session
      }.to change(Comment, :count).by(1)
    end

    it 'should assign the current user as creator of the new Comment' do
      @slide = FactoryGirl.create(:slide)
      params = { :slide_id => @slide.to_param, :comment => {} }

      post :create, params, valid_session

      Comment.last.creator.should == @user
    end
  end

  describe 'PUT update' do
    it 'should not throw a 406 if there is no slide_id' do
      pending 'no idea, try after you have more implemented'
      put :update, { :comment => FactoryGirl.build(:comment) }, valid_session
      response.status.should_not == 406
    end

    it 'should update the Comment whose id was passed in' do
      @slide = FactoryGirl.create(:slide)
      @comment = FactoryGirl.create(:comment)
      @slide.comments << @comment

      id = @comment.to_param
      text = 'text from spec PUT update'
      params = { 
        :id => id,
        :comment  => {:text => text} 
      }

      put :update, params, valid_session
      Comment.find(id).text.should == text 
    end
  end

  describe 'DELETE destroy' do
    it 'should not throw a 406 if there is no slide_id' do
      pending 'no idea, try after you have more implemented'
      delete :destroy, {}, valid_session
      response.status.should_not == 406
    end

    it 'should destroy the Comment whose id was passed in' do
      @comment = FactoryGirl.create(:comment)
      params = { :id => @comment.to_param }

      expect {
        delete :destroy, params, valid_session
      }.to change(Comment, :count).by(-1)
    end
  end

end
