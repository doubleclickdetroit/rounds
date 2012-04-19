require 'spec_helper'

describe User do
  before(:each) do
    @user = Factory(:user)
  end

  describe '.rounds' do
    it 'should return an array of Rounds' do
      @round = Factory(:round)
      @user.rounds << @round
      @user.rounds.should == [@round]
    end

    it 'should be able to limit the number of Rounds returned'
  end

  describe '.slides' do
    it 'should return an array of Slides' do
      @slide = Factory(:slide)
      @user.slides << @slide
      @user.slides.should == [@slide]
    end

    it 'should be able to limit the number of Slides returned'
  end

  describe '.comments' do
    it 'should return an array of Comments' do
      @comment = Factory(:comment)
      @user.comments << @comment
      @user.comments.should == [@comment]
    end

    it 'should be able to limit the number of Comments returned'
  end

  describe 'blocking functionality' do
    before(:each) do
      @user         = Factory(:user)
      @blocked_user = Factory(:user)
      @blentry      = Factory(:blacklist_entry, :user_fid => @user.fid, :blocked_fid => @blocked_user.fid)
    end

    describe '.blacklist_entries' do
      it 'should return an Array of BlackListEntries' do
        # todo this could be clearer but == doesnt work
        # on the Array since BLEntry doesnt have an id
        @user.blacklist_entries.first.blocked_fid.should == @blentry.blocked_fid 
      end
    end

    describe '.blacklist_fids' do
      it 'should map the BlacklistEntry fids to an Array' do
        @user.blocked_fids.should == [@blocked_user.fid]
      end
    end
  end

end
