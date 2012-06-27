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
        @sentence = FactoryGirl.build(:sentence, :round_id => @round.id, :user_id => @user.id).attributes
        @picture  = FactoryGirl.build(:picture, :round_id => @round.id, :user_id => @user.id).attributes
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
        @picture  = FactoryGirl.build(:picture, :round_id => @round.id, :user_id => @user.id).attributes
        @sentence = FactoryGirl.build(:sentence, :round_id => @round.id, :user_id => @user.id).attributes
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

      it 'should return AWS credentials for upload to S3' do
      end

      it 'should mark the record as not complete' 
      # it 'the round lock should be destroyed after the upload'
      # it 'background processing should take place after the upload'
    end

    it 'should raise without a proper slide[:type]' do
      slide = FactoryGirl.build(:sentence, :round_id => @round.id, :type => 'Foobar').attributes

      expect {
        Slide.create_next(slide)
      }.to raise_error('"Foobar" is not a valid slide type')

    end

    it 'should raise without a lock' do
      FactoryGirl.create(:sentence, :round_id => @round.id)
      slide = FactoryGirl.build(:picture, :round_id => @round.id).attributes
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
      slide = FactoryGirl.build(:picture, :round_id => @round.id).attributes
      expect {
        Slide.create_next(slide)
      }.to raise_error('User does not have the round locked')
    end

    # todo instead, create lock upon round creation
    it "shouldn't require a lock for the first slide..." 

    it 'should destroy the lock upon successful Sentence creation' do
      FactoryGirl.create(:picture, :round_id => @round.id)
      slide = FactoryGirl.build(:sentence, :round_id => @round.id, :user_id => @user.id).attributes

      RoundLock.count.should == 1
      expect {
        Slide.create_next(slide)
      }.to change(RoundLock, :count).by(-1)
    end

    it 'should set slide.ready to false upon successful Picture creation'
    it 'should not destroy the lock upon successful Picture creation' do
      pending 'only for production...'
      FactoryGirl.create(:sentence, :round_id => @round.id)
      slide = FactoryGirl.build(:picture, :round_id => @round.id, :user_id => @user.id).attributes

      RoundLock.count.should == 1
      expect {
        Slide.create_next(slide)
      }.to change(RoundLock, :count).by(0)
    end
  end

  klass = Slide

  it_should_have_a_creator(klass)

  it_should_scope_recent(klass)

  it_should_scope_friends(klass)

  it_should_scope_before_and_after(klass)

end
