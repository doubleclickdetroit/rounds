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

  describe '.created_by' do
    pending 'do i need to check this more thoroughly here or just in the controller spec?'

    it 'should return a User' do
      @comment.created_by = Factory(:user)
      @comment.created_by.should be_an_instance_of(User)
    end
  end

  describe '.creator' do
    it 'should simply call .created_by' do
      @comment.should_receive :created_by
      @comment.creator
    end
  end

end
