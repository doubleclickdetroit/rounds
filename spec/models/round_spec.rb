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
    s = @round.slides.first
    p = @round.slides.last
    s.position = 1 and s.save
    p.position = 0 and p.save
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

end
