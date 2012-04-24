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

  describe '.new_feed' do
    it 'should simply call Round.recent' do
      @user.stub(:reject_blocked).and_return([])
      Round.should_receive :recent
      @user.new_feed
    end

    it 'should also aggregate Slides (maybe Comments too)'

    pending 'ensure this tests Slides/Comments as well eventually'
    it 'should not return anything by a blocked User' do
      blocked_user = Factory(:user)
      Factory(:blacklist_entry, :user_fid => @user.fid, :blocked_fid => blocked_user.fid)
      6.times { Factory(:round, :fid => blocked_user.fid) }
      5.times { Factory(:round, :fid => blocked_user.fid+1) }

      @user.new_feed.count.should == 5
    end
  end

  describe '.friends_fids' do
    pending 'auth needs fleshed out first'
  end

  describe '.friends_feed' do
    it 'should simply call Round.friends_recent' do
      @user.stub(:friends_fids).and_return([1])
      Round.should_receive(:friends_recent).with(@user.friends_fids)
      @user.friends_feed
    end

    it 'should also aggregate Slides (maybe Comments too)'

    pending 'ensure this tests Slides/Comments as well eventually'
    it 'should not return anything by a blocked User' do
      blocked_user = Factory(:user)
      friend_user  = Factory(:user)
      Factory(:blacklist_entry, :user_fid => @user.fid, :blocked_fid => blocked_user.fid)
      6.times { Factory(:round, :fid => blocked_user.fid) }
      5.times { Factory(:round, :fid => friend_user.fid) }
      4.times { Factory(:round, :fid => friend_user.fid+1) }

      @user.stub(:friends_fids).and_return([friend_user.fid, blocked_user.fid])
      feed = @user.friends_feed
      feed.count.should == 5
    end
  end

  describe '.recent_activity' do
    it "should return the User's 30 most recent Rounds, Slides, and Comments (10/10/10 split)" do
      pending 'move this to a controller'
      15.times { Factory(:round,   :fid => @user.fid) }
      15.times { Factory(:slide,   :fid => @user.fid) }
      15.times { Factory(:comment, :fid => @user.fid) }

      puts "#############{@user.inspect}"
      json = ActiveSupport::JSON.decode @user.recent_activity
      puts "###############{json.inspect}"

      json[:rounds].size.should   == 10
      json[:slides].size.should   == 10
      json[:comments].size.should == 10
    end

    it 'should sort results properly'
    it 'should return json'
  end

end
