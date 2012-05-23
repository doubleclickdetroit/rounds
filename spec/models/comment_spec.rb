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

  it_should_have_a_creator(Comment)

  describe '.recent' do
    before(:each) do
      9.times { FactoryGirl.create(:comment) }
    end

    pending 'test recent? not just limit 8?'
    it 'should return the 8 most recent Comments' do
      Comment.recent.count.should == 8
    end
  end

  describe '.before' do
    pending
  end

  describe '.friends' do
    before(:each) do
      8.times { FactoryGirl.create(:comment) }
      friend1 = FactoryGirl.create(:user)
      friend2 = FactoryGirl.create(:user)
      FactoryGirl.create(:comment, :user_id => friend1.id)
      FactoryGirl.create(:comment, :user_id => friend2.id)
      @user_ids = [friend1.id, friend2.id]
    end

    it 'should only return Comments made by friends' do
      Comment.friends(@user_ids).count.should == 2
    end
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
