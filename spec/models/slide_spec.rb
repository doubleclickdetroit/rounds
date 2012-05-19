require 'spec_helper'

describe Slide do
  before(:each) do
    @round = FactoryGirl.create(:round)

    @slide = FactoryGirl.create(:slide) 
    @round.slides << @slide 

    @slide.comments << FactoryGirl.create(:comment)
    @slide.comments << FactoryGirl.create(:comment)
  end

  it 'should validate presence of round_id'

  it 'should belong to a Round' do
    @slide.round.should be_an_instance_of Round
  end

  it 'should have many Comments' do
    @slide.comments.all? do |comment|
      comment.instance_of?(Comment)
    end.should be_true
  end

  describe '.comment_count' do
    it 'should return the number of comments' do
      @slide.comment_count.should == @slide.comments.count
    end
  end

  it 'should have many Ballots' do
    @slide.ballots << FactoryGirl.create(:ballot)
    @slide.ballots << FactoryGirl.create(:ballot)

    @slide.ballots.all? do |ballot|
      ballot.instance_of?(Ballot)
    end.should be_true
  end

  describe '.create_next' do
    before(:each) do
      @user  = FactoryGirl.create(:user)
      @round = FactoryGirl.create(:round)
      @lock  = FactoryGirl.create(:round_lock, :round_id => @round.id, :user_id => @user.id)
    end

    context 'sentence' do
      before(:each) do
        FactoryGirl.create(:picture, :round_id => @round.id)
        @sentence = Factory.build(:sentence, :round_id => @round.id, :user_id => @user.id).attributes
        @picture  = Factory.build(:picture, :round_id => @round.id, :user_id => @user.id).attributes
      end

      it 'should allow a Sentence added after a Picture' do
        expect {
          Slide.create_next(@sentence)
        }.to change(Sentence, :count).by(1)
      end

      it 'should raise for a Picture after a Picture' do
        expect {
          Slide.create_next(@picture)
        }.to raise_error('Cannot create a picture after a picture')
      end
    end

    context 'picture' do
      before(:each) do
        FactoryGirl.create(:sentence, :round_id => @round.id)
        @picture  = Factory.build(:picture, :round_id => @round.id, :user_id => @user.id).attributes
        @sentence = Factory.build(:sentence, :round_id => @round.id, :user_id => @user.id).attributes
      end

      it 'should allow a Picture added after a Sentence' do
        expect {
          Slide.create_next(@picture)
        }.to change(Picture, :count).by(1)
      end

      it 'should raise for a Sentence after a Sentence' do
        expect {
          Slide.create_next(@sentence)
        }.to raise_error('Cannot create a sentence after a sentence')
      end
    end

    it 'should raise without a proper slide[:type]' do
      slide = Factory.build(:sentence, :round_id => @round.id, :type => 'Foobar').attributes

      expect {
        Slide.create_next(slide)
      }.to raise_error('"Foobar" is not a valid slide type')

    end

    it 'should raise without a lock' do
      FactoryGirl.create(:sentence, :round_id => @round.id)
      slide = Factory.build(:picture, :round_id => @round.id).attributes
      @lock.destroy 

      expect {
        Slide.create_next(slide)
      }.to raise_error('Cannot create slide without round lock')
    end

    it 'should raise if the RoundLock doesnt belong to the User' do
      user_id = 525
      FactoryGirl.create(:user, :id => user_id)
      @lock.user_id = user_id
      @lock.save

      FactoryGirl.create(:sentence, :round_id => @round.id)
      slide = Factory.build(:picture, :round_id => @round.id).attributes
      expect {
        Slide.create_next(slide)
      }.to raise_error('User does not have the round locked')
    end

    # todo instead, create lock upon round creation
    it "shouldn't require a lock for the first slide..." 

    it 'should destroy the lock upon successful slide creation' do
      FactoryGirl.create(:sentence, :round_id => @round.id)
      slide = Factory.build(:picture, :round_id => @round.id, :user_id => @user.id).attributes

      RoundLock.count.should == 1
      expect {
        Slide.create_next(slide)
      }.to change(RoundLock, :count).by(-1)
    end
  end

  describe 'after_create' do
    it 'should assign a position of 0 if it is the first Slide in the Round' do
      @round.slides = []
      slide = FactoryGirl.create(:slide, :round_id => @round.to_param)
      @round.slides << slide
      slide.position.should == 0
    end

    it 'should assign a position one greater than the last Slide in the Round' do
      @round.slides = []
      slide = FactoryGirl.create(:slide, :round_id => @round.to_param)
      @round.slides << slide
      slide = FactoryGirl.create(:slide, :round_id => @round.to_param)
      @round.slides << slide
      slide.position.should == 1
    end
  end

  describe '.created_by' do
    pending 'do i need to check this more thoroughly here or just in the controller spec?'

    it 'should return a User' do
      @slide.created_by = FactoryGirl.create(:user)
      @slide.created_by.should be_an_instance_of(User)
    end
  end

  describe '.creator' do
    it 'should simply call .created_by' do
      @slide.should_receive :created_by
      @slide.creator
    end
  end

  describe '.of_type' do
    before(:each) do
      # todo wasteful, 43 created before
      Slide.destroy_all

      FactoryGirl.create(:slide, :type => 'Sentence') 
      FactoryGirl.create(:slide, :type => 'Picture') 
    end

    it 'should only return Sentences when passed that type' do
      Slide.count.should == 2
      Slide.of_type('Sentence').count.should == 1
    end

    it 'should only return Pictures when passed that type' do
      Slide.count.should == 2
      Slide.of_type('Picture').count.should == 1
    end
  end

  describe '.recent' do
    before(:each) do
      9.times { FactoryGirl.create(:slide) }
    end

    pending 'test recent (by date)? not just limit 8?'
    it 'should return the 8 most recent Slides' do
      Slide.recent.count.should == 8
    end
  end

  describe '.before' do
    it 'should only return Slides created before a specific Time' do
      time = Time.now

      # todo wasteful
      Slide.destroy_all

      slide1 = FactoryGirl.create(:slide, :created_at => time-1)
      slide2 = FactoryGirl.create(:slide, :created_at => time+1)

      Slide.count.should == 2
      Slide.before(time).count.should == 1
 
    end
    pending 'actual test of time'
  end

  describe '.friends' do
    before(:each) do
      8.times { FactoryGirl.create(:slide) }
      friend1 = FactoryGirl.create(:user)
      friend2 = FactoryGirl.create(:user)
      FactoryGirl.create(:slide, :user_id => friend1.id)
      FactoryGirl.create(:slide, :user_id => friend2.id)
      @user_ids = [friend1.id, friend2.id]
    end

    it 'should only return Slides made by friends' do
      Slide.friends(@user_ids).count.should == 2
    end
  end

  describe '.friends_recent' do
    before(:each) do
      8.times { FactoryGirl.create(:slide) }
      friend1 = FactoryGirl.create(:user)
      friend2 = FactoryGirl.create(:user)
      4.times { FactoryGirl.create(:slide, :user_id => friend1.id) }
      5.times { FactoryGirl.create(:slide, :user_id => friend2.id) }
      @user_ids = [friend1.id, friend2.id]
    end

    it 'should only return 8 Slides at most' do
      Slide.friends_recent(@user_ids).count.should == 8
    end
  end

  describe '.friends_recent_for' do
    before(:each) do
      @user  = FactoryGirl.create(:user)
      friend = FactoryGirl.create(:user)
      9.times { FactoryGirl.create(:slide, :user_id => friend.id) }
      @user.stub(:friends_user_ids).and_return([friend.id])
    end

    it 'should only return 8 Slides at most' do
      Slide.friends_recent_for(@user).count.should == 8
    end
  end

  describe ".of_type_and_before" do
    before(:each) do
      @time = Time.now
      5.times { FactoryGirl.create(:sentence, :created_at => @time) }
      5.times { FactoryGirl.create(:picture, :created_at => @time) }
      @time += 30 # arbitrary
      4.times { FactoryGirl.create(:sentence, :created_at => @time) }
      4.times { FactoryGirl.create(:picture, :created_at => @time) }
    end

    [Sentence,Picture].each do |klass|
      it "should return the 8 most recent slides of the proper type (#{klass.to_s}) with no time arg" do
        slides = Slide.of_type_and_before(klass.to_s)
        slides.count.should == 8 # todo spec most recent instead
        slides.all?{|s|s.instance_of?(klass)}.should be_true
      end

      it "should return the slides before the proper time and of the proper type (#{klass.to_s})" do
        slides = Slide.of_type_and_before(klass.to_s, @time)
        slides.count.should == 5 
        slides.all?{|s|s.instance_of?(klass)}.should be_true
      end
    end
  end

end
