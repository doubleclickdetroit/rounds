require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  describe '.rounds' do
    it 'should return an array of Rounds' do
      @round = FactoryGirl.create(:round)
      @user.rounds << @round
      @user.rounds.should == [@round]
    end

    it 'should be able to limit the number of Rounds returned'
  end

  describe '.slides' do
    it 'should return an array of Slides' do
      @slide = FactoryGirl.create(:slide)
      @user.slides << @slide
      @user.slides.should == [@slide]
    end

    it 'should be able to limit the number of Slides returned'
  end

  describe '.comments' do
    it 'should return an array of Comments' do
      @comment = FactoryGirl.create(:comment)
      @user.comments << @comment
      @user.comments.should == [@comment]
    end

    it 'should be able to limit the number of Comments returned'
  end

  describe '.watchings' do
    it 'should return an array of Watchings' do
      @watching = FactoryGirl.create(:watching)
      @user.watchings << @watching
      @user.watchings.should == [@watching]
    end

    it 'should be able to limit the number of Watchings returned'
  end

  describe 'blocking functionality' do
    before(:each) do
      @user         = FactoryGirl.create(:user)
      @blocked_user = FactoryGirl.create(:user)
      @blentry      = FactoryGirl.create(:blacklist_entry, :fid => @user.id, :blocked_fid => @blocked_user.id)
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
        @user.blocked_fids.should == [@blocked_user.id]
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
      blocked_user = FactoryGirl.create(:user)
      FactoryGirl.create(:blacklist_entry, :fid => @user.id, :blocked_fid => blocked_user.id)
      6.times { FactoryGirl.create(:round, :fid => blocked_user.id) }
      5.times { FactoryGirl.create(:round, :fid => "#{blocked_user.id.to_i+1}") }

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
      blocked_user = FactoryGirl.create(:user)
      friend_user  = FactoryGirl.create(:user)
      FactoryGirl.create(:blacklist_entry, :fid => @user.id, :blocked_fid => blocked_user.id)
      6.times { FactoryGirl.create(:round, :fid => blocked_user.id) }
      5.times { FactoryGirl.create(:round, :fid => friend_user.id) }
      4.times { FactoryGirl.create(:round, :fid => "#{friend_user.id.to_i+1}") }

      @user.stub(:friends_fids).and_return([friend_user.id, blocked_user.id])
      feed = @user.friends_feed
      feed.count.should == 5
    end
  end

end
