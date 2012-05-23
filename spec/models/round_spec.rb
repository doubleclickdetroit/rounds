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

  klass = Round

  it_should_have_a_creator(klass)

  it_should_scope_recent(klass)

  it_should_scope_friends(klass)

  it_should_scope_before_and_after(klass)

end
