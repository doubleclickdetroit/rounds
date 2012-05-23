require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  describe '.authorizations' do
    it 'should have many Authorizations' do
      @authorization = FactoryGirl.create(:authorization)
      @user.authorizations << @authorization
      @user.save
      @user.reload.authorizations.should == [@authorization]
    end
  end

  describe '.rounds' do
    it 'should return an array of Rounds' do
      @round = FactoryGirl.create(:round)
      @user.rounds << @round
      @user.rounds.should == [@round]
    end
  end

  describe '.slides' do
    it 'should return an array of Slides' do
      @slide = FactoryGirl.create(:slide)
      @user.slides << @slide
      @user.slides.should == [@slide]
    end
  end

  describe '.comments' do
    it 'should return an array of Comments' do
      @comment = FactoryGirl.create(:comment)
      @user.comments << @comment
      @user.comments.should == [@comment]
    end
  end

  describe '.watchings' do
    it 'should return an array of Watchings' do
      @watching = FactoryGirl.create(:watching)
      @user.watchings << @watching
      @user.watchings.should == [@watching]
    end
  end

  describe 'blocking functionality' do
    pending 'blocked ids filter'

    before(:each) do
      @user         = FactoryGirl.create(:user)
      @blocked_user = FactoryGirl.create(:user)
      @blentry      = FactoryGirl.create(:blacklist_entry, :user_id => @user.id, :blocked_user_id => @blocked_user.id)
    end

    describe '.blacklist_entries' do
      it 'should return an Array of BlackListEntries' do
        # todo this could be clearer but == doesnt work
        # on the Array since BLEntry doesnt have an id
        @user.blacklist_entries.first.blocked_user_id.should == @blentry.blocked_user_id 
      end
    end

    describe '.blacklist_user_ids' do
      it 'should map the BlacklistEntry user_ids to an Array' do
        @user.blocked_user_ids.should == [@blocked_user.id]
      end
    end
  end

  describe '.friend_ids' do
    pending 'auth needs fleshed out first'
  end

  describe '#via_auth' do
    before(:each) do
      @user.destroy
      @auth_hash = {
        'provider' => 'facebook',
        'uid' => '1337',
        'info' => {
          'name' => 'Fox McCloud'
        }
      }
    end

    context 'where User exists' do
      context 'and where Authorization exists' do
        before(:each) do
          @user = FactoryGirl.create(:user, :name => @auth_hash['info']['name'])
          @auth = FactoryGirl.create(:authorization, :user_id => @user.id, :provider => @auth_hash['provider'], :uid => @auth_hash['uid'])
        end

        it 'should find the Authorization from the hash' do
          pending 'how do i spec this?'
          # Authorization.should_receive(:find_or_initialize_by_provider_and_uid).with(@auth_hash['provider'], @auth_hash['uid'])
          User.via_auth(@auth_hash)
        end

        it 'should return the associated User' do
          User.via_auth(@auth_hash).should == @user
        end
      end

      context 'and where no Authorization exists' do
        it 'should create an Authorization' do
          expect {
            User.via_auth(@auth_hash)
          }.to change(Authorization, :count).by(1)
        end

        it 'should create a User' do
          expect {
            User.via_auth(@auth_hash)
          }.to change(User, :count).by(1)
        end

        it 'should associate the Authorization and the User' do
          Authorization.count.should == 0
          User.count.should == 0

          User.via_auth(@auth_hash)

          Authorization.last.user.should == User.last
        end
      end
    end

    context 'where no user exists' do
      pending "not sure if this is it, but theres another case im not spec'ing..."
    end
  end

  describe '#find_by_auth_hash' do
    before(:each) do
      @auth_hash = {
        'provider' => 'facebook',
        'uid' => '1337',
        'info' => {
          'name' => 'Fox McCloud'
        }
      }
      @user = FactoryGirl.create(:user, :name => @auth_hash['info']['name'])
      @auth = FactoryGirl.create(:authorization, :user_id => @user.id, :provider => @auth_hash['provider'], :uid => @auth_hash['uid'])
    end

    it 'should return the associated User' do
      User.find_by_auth_hash(@auth_hash).should == @user
    end
  end

end
