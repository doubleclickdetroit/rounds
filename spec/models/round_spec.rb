require 'spec_helper'

describe Round do
  before(:each) do
    @round = Factory(:round)
    @round.slides << Factory(:slide)
    @round.slides << Factory(:slide)
  end

  it 'should have many Slides' do
    @round.slides.all? do |slide|
      slide.kind_of?(Slide)
    end.should be_true
  end

  it 'should have Slides of class Sentence'
  it 'should have Slides of class Picture'

  it 'should return Slides in order'
end
