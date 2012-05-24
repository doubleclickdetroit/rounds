require 'spec_helper'

describe Comment do
  before(:each) do
    @comment = FactoryGirl.create(:comment)
    @slide   = FactoryGirl.create(:slide) 
    @slide.comments << @comment
  end

  it 'should belong to a Slide' do
    @comment.slide.should == @slide
  end

  klass = Comment

  it_should_have_a_creator(klass)

  it_should_scope_recent(klass)

  it_should_scope_friends(klass)

  it_should_scope_before_and_after(klass)

end
