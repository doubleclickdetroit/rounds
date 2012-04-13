require 'spec_helper'

describe Comment do
  before(:each) do
    @comment = Factory(:comment)

    @slide   = Factory(:slide) 
    @slide.comments << @comment
  end

  it 'should belong to a Slide' do
    @comment.slide.should == @slide
  end
end
