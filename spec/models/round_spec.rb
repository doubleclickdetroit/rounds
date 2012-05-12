require 'spec_helper'

describe Round do
  before(:each) do
    @round = Factory(:round)
    @round.slides << Factory.build(:sentence)
    @round.slides << Factory.build(:picture)
  end

  it 'should have many Slides' do
    @round.slides.all? do |slide|
      slide.kind_of?(Slide)
    end.should be_true
  end

  it 'should have many Invitations', :focus do
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

  it 'should return Slides in order' do
    # the first shall be last...
    puts @round.slides.inspect
    @round.slides << Factory(:sentence)
    @round.slides << Factory(:picture)
    @round.save
    @round.slides.first.position = 1 
    @round.slides.last.position = 0 
    @round.save
    @round.reload
    # forces position opposite
    # of chronological creation

    # each position should be one
    # greater than the previous
    slides_are_ordered_by_position = true
    positions = @round.slides.map {|s| s.position}
    last = -2
    positions.each do |pos|
      last = last + 1
      slides_are_ordered_by_position = false unless (last + 1) == pos
    end

    slides_are_ordered_by_position.should be_true
  end

  describe '.created_by' do
    pending 'do i need to check this more thoroughly here or just in the controller spec?'

    it 'should return a User' do
      @round.created_by = Factory(:user)
      @round.created_by.should be_an_instance_of(User)
    end
  end

  describe '.creator' do
    it 'should simply call .created_by' do
      @round.should_receive :created_by
      @round.creator
    end
  end

  describe '.recent' do
    before(:each) do
      9.times { Factory(:round) }
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
      8.times { Factory(:round) }
      friend1 = Factory(:user)
      friend2 = Factory(:user)
      Factory(:round, :fid => friend1.fid)
      Factory(:round, :fid => friend2.fid)
      @fids = [friend1.fid, friend2.fid]
    end

    it 'should only return Rounds made by friends' do
      Round.friends(@fids).count.should == 2
    end
  end

  describe '.friends_recent' do
    before(:each) do
      friend = Factory(:user)
      9.times { Factory(:round, :fid => friend.fid) }
      @fids = [friend.fid]
    end

    it 'should only return 8 Rounds at most' do
      Round.friends_recent(@fids).count.should == 8
    end
  end

end
