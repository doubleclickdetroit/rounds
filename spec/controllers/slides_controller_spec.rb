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
      @slide = Factory(:slide, :round_id => @round.id)
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

  describe 'GET recent' do
    pending 'unhappy path'

    before(:each) do 
      @time = Time.now
      3.times { Factory(:sentence, :created_at => @time) }
      3.times { Factory(:picture, :created_at => @time) }
    end

    context 'with no time arg' do
      [Sentence,Picture].each do |klass|
        context klass.to_s do
          it "should assign only proper number of #{klass.to_s.pluralize} to @slides" do 
            get :recent, {:type => klass.to_s}, valid_session

            assigns(:slides).count.should == 3
            assigns(:slides).all?{|s|s.instance_of?(klass)}.should be_true
          end
        end
      end
    end
    
    context 'with time arg' do
      before(:each) do 
        @time += 30 # arbitrary
        2.times { Factory(:sentence, :created_at => @time) }
        2.times { Factory(:picture, :created_at => @time) }
      end

      [Sentence,Picture].each do |klass|
        context klass.to_s do
          it "should assign only proper number of #{klass.to_s.pluralize} to @slides" do 
            get :recent, {:type => klass.to_s, :time => @time}, valid_session

            assigns(:slides).count.should == 3
            assigns(:slides).all?{|s|s.instance_of?(klass)}.should be_true
          end
        end
      end
    end

  end

  describe 'GET friends' do
    pending 'unhappy path'

    before(:each) do
      other_fid  = 1
      friend_fid = 2

      User.any_instance.stub(:friends_fids).and_return([friend_fid])

      @time = Time.now

      params = {}
      params[:created_at] = @time
      params[:fid]        = other_fid

      # other slides
      2.times { Factory(:sentence, params) }
      2.times { Factory(:picture, params) }

      # friends slides
      params[:fid] = friend_fid
      5.times { Factory(:sentence, params) }
      5.times { Factory(:picture, params) }
      @time += 30 # arbitrary
      params[:created_at] = @time
      4.times { Factory(:sentence, params) }
      4.times { Factory(:picture, params) }
    end

    pending 'no time arg'

    [Sentence,Picture].each do |klass|
      it "should return the most recent slides by friends of the proper type (#{klass.to_s}) with no time arg" do
        get :friends, {:type => klass.to_s}, valid_session

        slides = assigns(:slides)
        # slides.each {|slide| puts "############{slide.inspect}"}

        slides.count.should == 5 # todo spec most recent instead
        slides.all?{|s|s.instance_of?(klass)}.should be_true
      end

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
