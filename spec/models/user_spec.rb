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

  describe '.ballots' do
    it 'should return an array of ballots' do
      @ballot = FactoryGirl.create(:ballot)
      @user.ballots << @ballot
      @user.ballots.should == [@ballot]
    end
  end

  describe '.watchings' do
    it 'should return an array of Watchings' do
      @watching = FactoryGirl.create(:watching)
      @user.watchings << @watching
      @user.watchings.should == [@watching]
    end
  end

  # todo this kind of doesnt make sense
  describe '.invitations' do
    it "should return Invitations where the invited_user_id is the User's id" do
      @invitation1 = FactoryGirl.create(:invitation, :invited_user_id => @user.id)
      @user.invitations.should == [@invitation1]
      @invitation2 = FactoryGirl.create(:invitation)
      @user.invitations << @invitation2
      @user.save
      @user.reload
      @invitation2.invited_user_id== @user.id
      @user.invitations.should == [@invitation1,@invitation2]
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
          'name' => 'Fox McCloud',
          'image' => 'http://foo.bar'
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
      
      pending 'for facebook only'
      it 'should save the image to User.image_path' do
        user = User.via_auth(@auth_hash)
        user.image_path.should == @auth_hash['info']['image']
      end
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

  describe '.friend_ids' do
    pending 'default to String.new'

    it 'should return [] if .friend_ids_csv is nil' do
      @user.friend_ids_csv = nil
      @user.friend_ids.should == []
    end

    it 'should return .friend_ids_csv as an Array of strings' do
      str = '1,2,3'
      @user.friend_ids_csv = str
      @user.friend_ids.should == %w(1 2 3)
    end
  end

  describe '.friend_ids=' do
    it 'should join an Array of ints and assign them to .friend_ids_csv as a String' do
      arr = [1,2,3]
      @user.friend_ids_csv.should == nil
      @user.friend_ids = arr
      @user.friend_ids.should == %w(1 2 3)
      @user.friend_ids_csv.should == '1,2,3'
    end

  end

  describe '.friends' do
    before(:each) do
      @friend   = FactoryGirl.create(:user)
      @user.friend_ids_csv = @friend.id.to_s

      @blocked = FactoryGirl.create(:user)
      FactoryGirl.create(:blacklist_entry, user_id: @user.id, blocked_user_id: @blocked.id)

      @stranger = FactoryGirl.create(:user)
    end

    klasses = [Round, Slide, Comment]

    klasses.each do |klass|
      context "for #{klass}" do
        before(:each) do
          @klass_sym = klass.to_s.downcase.intern

          @mine          = FactoryGirl.create(@klass_sym, :user => @user)
          @friends       = FactoryGirl.create(@klass_sym, :user => @friend)
          @strangers     = FactoryGirl.create(@klass_sym, :user => @stranger)
          @blocked_users = FactoryGirl.create(@klass_sym, :user => @blocked)
        end

        describe '.own' do
          before(:each) do
            @plural     = klass.to_s.pluralize
            @plural_sym = @plural.downcase.intern

            8.times { FactoryGirl.create(@klass_sym, :user => @user) }

            # latest created not by @user
            FactoryGirl.create(@klass_sym, :user => @friend)
            FactoryGirl.create(@klass_sym, :user => @stranger)
          end

          it "should return [] if the User has no #{@plural}" do
            instances = @user.send @plural_sym
            instances.destroy_all
            instances.reload.count.should == 0

            @user.own(klass).count.should == 0
          end

          it 'should only return results for the User' do
            instances = @user.send @plural_sym
            instances.all {|i| i.instance_of? klass}.should be_true
          end

          it 'should sort the results'

          it 'should limit the results to 8' do
            instances = @user.send @plural_sym
            instances.count.should == 9

            @user.own(klass).count.should == 8
          end
        end

        describe '.filter_blocked' do
          it 'should return eight_most_recent' do
            klass.should_receive :eight_most_recent
            @user.filter_blocked(klass)
          end

          it "should not return instances of the #{klass} for which the user_id is in blocked_user_ids" do
            @user.blocked_user_ids.should == [@blocked.id]

            @user.filter_blocked(klass).should_not include(@blocked_users)
          end

          it 'should sort the results'

          it 'should limit the results to 8' do
            9.times { FactoryGirl.create(@klass_sym, :user => @friend) }
            klass.count.should > 8
            @user.filter_blocked(klass).count == 8
          end
        end

        describe '.friends' do
          it 'should return [] if the user has no friends' do
            @user.friend_ids = []
            @user.friend_ids.should == []

            @user.friends(klass).should == []
          end

          it "should return only instances of the #{klass} for which the user_id belongs to .friends_ids" do
            @user.friend_ids.should == [@friend.id.to_s]

            @user.friends(klass).should == [@friends]
          end

          it "should not return instances of the #{klass} for which the user_id is in blocked_user_ids" do
            8.times { FactoryGirl.create(@klass_sym, user: @friend) }

            @user.friend_ids = (@user.friend_ids << @blocked.id.to_s)
            # making this one eighth and the most recent
            @blocked_users = FactoryGirl.create(@klass_sym, :user => @blocked)

            @user.friend_ids.should       == [@friend.id.to_s,@blocked.id.to_s]
            @user.blocked_user_ids.should == [@blocked.id]
            klass.count.should > 8

            @user.friends(klass).should_not include(@blocked_users)
          end
        end

        describe '.recent' do
          context "with more than 8 #{klass.to_s.pluralize}" do
            before(:each) do
              8.times { FactoryGirl.create(@klass_sym) }

              # making this one eighth and the most recent
              @blocked_users = FactoryGirl.create(@klass_sym, :user => @blocked)
            end

            it "should not return instances of the #{klass} for which the user_id is in blocked_user_ids" do
              8.times { FactoryGirl.create(@klass_sym) }

              # making this one eighth and the most recent
              @blocked_users = FactoryGirl.create(@klass_sym, :user => @blocked)

              @user.blocked_user_ids.should == [@blocked.id]
              klass.count.should > 8

              @user.recent(klass).should_not include(@blocked_users)
            end

            it "should not return instances of the #{klass} for which the user_id is in blocked_user_ids" do
              @user.blocked_user_ids.should == [@blocked.id]
              klass.count.should > 8

              @user.recent(klass).should_not include(@blocked_users)
            end
          end

          it "should not return #{klass.to_s.pluralize} belonging to @user" do
            klass.count.should == 4

            @user.recent(klass).should_not include(@mine)
          end
        end
      end
    end
  end

end
