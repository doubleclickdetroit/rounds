require 'spec_helper'

describe Slide do
  before(:each) do
    @slide = Factory(:slide) 
    @round = Factory(:round)
    @round.slides << @slide 
  end

  it 'should belong to a Round' do
    @slide.round.should == @round
  end
end
