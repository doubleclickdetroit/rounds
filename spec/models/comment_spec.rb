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

  describe '.before' do
    pending
  end

  describe '.friends_recent' do
    before(:each) do
      friend = FactoryGirl.create(:user)
      9.times { FactoryGirl.create(:comment, :user_id => friend.id) }
      @user_ids = [friend.id]
    end

    it 'should only return 8 Comments at most' do
      Comment.friends_recent(@user_ids).count.should == 8
    end
  end

end
