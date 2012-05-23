require 'spec_helper'

describe Round do
  before(:each) do
    @round = FactoryGirl.create(:round)
    @round.slides << FactoryGirl.build(:sentence)
    @round.slides << FactoryGirl.build(:picture)
  end

  it 'should have many Slides' do
    @round.slides.all? do |slide|
      slide.kind_of?(Slide)
    end.should be_true
  end

  it 'should have many Invitations' do
    @round.invitations.all? do |invitation|
      invitation.kind_of?(Invitation)
    end.should be_true
  end

  it 'should have Slides of class Sentence' do
    @round.slides.any? do |slide|
      slide.instance_of?(Sentence)
    end.should be_true
  end

  it 'should have Slides of class Picture' do
    @round.slides.any? do |slide|
      slide.kind_of?(Picture)
    end.should be_true
  end

  it 'should return .slides in order of their created_by'

  it_should_have_a_creator(Round)

  describe '.recent' do
    before(:each) do
      9.times { FactoryGirl.create(:round) }
    end

    pending 'test recent? not just limit 8?'
    it 'should return the 8 most recent Rounds' do
      Round.recent.count.should == 8
    end
  end

  describe '.before' do
    pending
  end

  describe '.friends' do
    before(:each) do
      8.times { FactoryGirl.create(:round) }
      friend1 = FactoryGirl.create(:user)
      friend2 = FactoryGirl.create(:user)
      FactoryGirl.create(:round, :user_id => friend1.id)
      FactoryGirl.create(:round, :user_id => friend2.id)
      @user_ids = [friend1.id, friend2.id]
    end

    it 'should only return Rounds made by friends' do
      Round.friends(@user_ids).count.should == 2
    end
  end

  describe '.friends_recent' do
    before(:each) do
      friend = FactoryGirl.create(:user)
      9.times { FactoryGirl.create(:round, :user_id => friend.id) }
      @user_ids = [friend.id]
    end

    it 'should only return 8 Rounds at most' do
      Round.friends_recent(@user_ids).count.should == 8
    end
  end

end
