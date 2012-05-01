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

  describe '.recent' do
    before(:each) do
      9.times { Factory(:comment) }
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
      8.times { Factory(:comment) }
      friend1 = Factory(:user)
      friend2 = Factory(:user)
      Factory(:comment, :fid => friend1.fid)
      Factory(:comment, :fid => friend2.fid)
      @fids = [friend1.fid, friend2.fid]
    end

    it 'should only return Comments made by friends' do
      Comment.friends(@fids).count.should == 2
    end
  end

  describe '.friends_recent' do
    before(:each) do
      friend = Factory(:user)
      9.times { Factory(:comment, :fid => friend.fid) }
      @fids = [friend.fid]
    end

    it 'should only return 8 Comments at most' do
      Comment.friends_recent(@fids).count.should == 8
    end
  end

end
