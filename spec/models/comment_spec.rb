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

  describe '.created_by' do
    pending 'do i need to check this more thoroughly here or just in the controller spec?'

    it 'should return a User' do
      @comment.created_by = FactoryGirl.create(:user)
      @comment.created_by.should be_an_instance_of(User)
    end
  end

  describe '.creator' do
    it 'should simply call .created_by' do
      @comment.should_receive :created_by
      @comment.creator
    end
  end

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
      FactoryGirl.create(:comment, :user_id => friend1.user_id)
      FactoryGirl.create(:comment, :user_id => friend2.user_id)
      @user_ids = [friend1.user_id, friend2.user_id]
    end

    it 'should only return Comments made by friends' do
      Comment.friends(@user_ids).count.should == 2
    end
  end

  describe '.friends_recent' do
    before(:each) do
      friend = FactoryGirl.create(:user)
      9.times { FactoryGirl.create(:comment, :user_id => friend.user_id) }
      @user_ids = [friend.user_id]
    end

    it 'should only return 8 Comments at most' do
      Comment.friends_recent(@user_ids).count.should == 8
    end
  end

end
