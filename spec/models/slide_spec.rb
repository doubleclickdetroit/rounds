require 'spec_helper'

describe Slide do
  before(:each) do
    @slide = Factory(:slide) 

    @round = Factory(:round)
    @round.slides << @slide 

    @slide.comments << Factory(:comment)
    @slide.comments << Factory(:comment)
  end

  it 'should belong to a Round' do
    @slide.round.should == @round
  end

  it 'should have many Comments' do
    @slide.comments.all? do |comment|
      comment.instance_of?(Comment)
    end.should be_true
  end
end
