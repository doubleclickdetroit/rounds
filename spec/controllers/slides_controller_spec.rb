require 'spec_helper'

describe SlidesController do
  attr_accessor :valid_attributes, :valid_session

  login_user()

  before(:each) { Slide.any_instance.stub(:content).and_return('') }

  describe 'GET index' do
    it_should_properly_assign_user(action: :index, by_user_id: true)

    it_should_handle_index_by_parent_id(Slide, Round)
    it_should_handle_before_and_after_for_action_and_by_current_user(Slide, :index)
  end

  describe 'GET show' do
    it 'should return a given Slide' do
      @slide = FactoryGirl.create(:slide)
      params = { :id => @slide.to_param }

      Slide.should_receive(:find).with(@slide.to_param)
      get :show, params, valid_session
    end
  end

  describe 'GET show' do
    it 'should not throw a 406 if there is no slide_id' do
      pending 'no idea, try after you have more implemented'
      put :update, { :slide => FactoryGirl.build(:slide) }, valid_session 
      response.status.should_not == 406
    end

    it 'should show Slides for a Round' do
      pending 'need for a show action'
      @round = FactoryGirl.create(:round)
      @slide = FactoryGirl.create(:slide)
      @round.slides << @slide
      params = { :round_id => @round.to_param }

      get :show, params, valid_session
      assigns(:slides).should == [@slide]
    end
  end

  describe 'POST create' do
    describe 'with incorrect params' do
      it 'should throw a 406 if there is no round_id' do
        post :create, {:type => 'Sentence'}, valid_session 
        response.status.should == 406
      end

      it 'should throw a 406 if there is no type' do
        post :create, {:round_id => '1'}, valid_session 
        response.status.should == 406
      end

      it "should make sure the user's user_id is in params[:slide]"
    end

    describe 'without RoundLock' do
      it 'should create a new Sentence' do
        pending 'rescue errors to :bad_request or something?'
        @round = FactoryGirl.create(:round)
        FactoryGirl.create(:picture, :round_id => @round.id)
        FactoryGirl.create(:round_lock, :round_id => @round.id)
        slide  = FactoryGirl.build(:sentence).attributes
        params = { :round_id => @round.to_param, :slide => slide }

        expect {
          post :create, params, valid_session
        }.to change(Slide, :count).by(1)
      end

      it 'should create a new Picture' do
        pending 'rescue errors to :bad_request or something?'
        @round = FactoryGirl.create(:round)
        FactoryGirl.create(:sentence, :round_id => @round.id)
        FactoryGirl.create(:round_lock, :round_id => @round.id)
        slide  = FactoryGirl.build(:picture).attributes
        params = { :round_id => @round.to_param, :slide => slide }

        expect {
          post :create, params, valid_session
        }.to change(Slide, :count).by(0)
      end
    end

    describe 'with RoundLock' do
      it 'should create a new Sentence' do
        @round = FactoryGirl.create(:round)
        @lock  = FactoryGirl.create(:round_lock, :round_id => @round.id, :user_id => @user.id)
        FactoryGirl.create(:picture, :round_id => @round.id)
        FactoryGirl.create(:round_lock, :round_id => @round.id)
        slide  = FactoryGirl.build(:sentence).attributes
        params = { :round_id => @round.to_param, :slide => slide }

        expect {
          post :create, params, valid_session
        }.to change(Slide, :count).by(1)
      end

      it 'should create a new Picture' do
        @round = FactoryGirl.create(:round)
        @lock  = FactoryGirl.create(:round_lock, :round_id => @round.id, :user_id => @user.id)
        FactoryGirl.create(:sentence, :round_id => @round.id)
        FactoryGirl.create(:round_lock, :round_id => @round.id)
        slide  = FactoryGirl.build(:picture).attributes
        params = { :round_id => @round.to_param, :slide => slide }

        expect {
          post :create, params, valid_session
        }.to change(Slide, :count).by(1)
      end

      it 'should create a new Slide with current_user as creator' do
        @round = FactoryGirl.create(:round)
        @lock  = FactoryGirl.create(:round_lock, :round_id => @round.id, :user_id => @user.id)
        FactoryGirl.create(:picture, :round_id => @round.id)
        FactoryGirl.create(:round_lock, :round_id => @round.id)
        slide  = FactoryGirl.build(:sentence).attributes
        params = { :round_id => @round.to_param, :slide => slide }

        post :create, params, valid_session

        Slide.last.creator.should == @user
      end
    end
  end

  describe 'PUT update' do
    it 'should not throw a 406 if there is no slide_id' do
      pending 'no idea, try after you have more implemented'
      put :update, { :slide => FactoryGirl.build(:slide) }, valid_session 
      response.status.should_not == 406
    end

    it 'should update the Slide whose id was passed in' do
      @slide = FactoryGirl.create(:slide)

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
      @slide = FactoryGirl.create(:slide)
      params = { :id => @slide.to_param }

      expect {
        delete :destroy, params, valid_session
      }.to change(Slide, :count).by(-1)
    end
  end

  describe 'GET community' do
    pending 'unhappy path'

    pending 'sick of dealing with this right now'
    # it_should_handle_before_and_after_for_action(Slide, :community)
  end

  describe 'GET friends' do
    pending 'unhappy path'

    before(:each) do
      other_user_id  = 1
      friend_user_id = 2

      User.any_instance.stub(:friends_user_ids).and_return([friend_user_id])

      @time = Time.now

      params = {}
      params[:created_at] = @time
      params[:user_id]        = other_user_id

      # other slides
      2.times { FactoryGirl.create(:sentence, params) }
      2.times { FactoryGirl.create(:picture, params) }

      # friends slides
      params[:user_id] = friend_user_id
      5.times { FactoryGirl.create(:sentence, params) }
      5.times { FactoryGirl.create(:picture, params) }
      @time += 30 # arbitrary
      params[:created_at] = @time
      4.times { FactoryGirl.create(:sentence, params) }
      4.times { FactoryGirl.create(:picture, params) }
    end

    [Sentence,Picture].each do |klass|
      it "should return [] for #{klass.to_s.downcase}#friends if the User has no friends" do # BURN!
        User.any_instance.stub(:friends_user_ids).and_return([])

        get :friends, {:type => klass.to_s}, valid_session

        assigns(:slides).should == []
      end
    end

    context 'without time arg' do
      [Sentence,Picture].each do |klass|
        it "should return the most recent slides by friends of the proper type (#{klass.to_s}) with no time arg" do
          pending 'proper auth/friends_ids'
          get :friends, {:type => klass.to_s}, valid_session

          slides = assigns(:slides)

          slides.count.should == 8 # todo spec most recent instead
          slides.all?{|s|s.instance_of?(klass)}.should be_true
        end
      end
    end

    context 'with time arg' do
      [Sentence,Picture].each do |klass|
        it "should return the slides by friends before the proper time and of the proper type (#{klass.to_s})" do
          pending 'failing on @time'
          get :friends, {:type => klass.to_s, :time => @time}, valid_session

          slides = assigns(:slides)

          slides.count.should == 5 
          slides.all?{|s|s.instance_of?(klass)}.should be_true
        end
      end
    end

  end

  describe 'GET feed' do
    pending '... how do i spec this?'

    [Sentence, Picture].each do |klass|
      describe "for #{klass}" do
        it 'should bomb without type?'

        it 'shouldnt bomb' do
          get :feed, {:type => klass.to_s}, valid_session
        end
      end
    end
  end

end
