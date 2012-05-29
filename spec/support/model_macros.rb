module ModelMacros
  def it_should_have_a_creator(klass)
    context 'belongs to a User' do
      before(:each) do
        klass.destroy_all

        user = FactoryGirl.create(:user)

        @instance = FactoryGirl.create(klass.to_s.downcase.intern) 
        @instance.user = user
        @instance.save
        @instance.reload
      end

      describe '.created_by' do
        it 'should return a User' do
          @instance.created_by.should be_an_instance_of(User)
        end
      end

      describe '.creator' do
        it 'should simply call .created_by' do
          @instance.should_receive :created_by
          @instance.creator
        end
      end
    end
  end

  def it_should_scope_recent(klass)
    context 'recent scoping' do
      before(:each) do
        klass.destroy_all

        @user = FactoryGirl.create(:user)
        4.times { FactoryGirl.create(klass.to_s.downcase.intern) }
        @other_user = FactoryGirl.create(:user)
        5.times { FactoryGirl.create(klass.to_s.downcase.intern, :user_id => @other_user.id) }
      end

      pending '.eight_most_recent'

      describe '.recent' do
        it "should return the 8 most recent #{klass.to_s.pluralize}" do
          klass.recent(@user).count.should == 8
        end

        it 'should not return anything by a blocked user' do
          @blocked_user = @other_user
          FactoryGirl.create(:blacklist_entry, :user_id => @user.id, :blocked_user_id => @blocked_user.id)

          @user.blocked_user_ids.should == [@blocked_user.id]

          klass.recent(@user).count.should == 4
        end
      end
    end
  end

  def it_should_scope_friends(klass)
    context 'friend scoping' do
      before(:each) do
        klass.destroy_all

        sym = klass.to_s.downcase.intern

        @user = FactoryGirl.create(:user)

        8.times { FactoryGirl.create(sym) }

        friend1 = FactoryGirl.create(:user)
        friend2 = FactoryGirl.create(:user)

        FactoryGirl.create(sym, :user_id => friend1.id)
        FactoryGirl.create(sym, :user_id => friend2.id)

        @user.stub(:friend_ids).and_return([friend1.id, friend2.id])
      end

      describe '.by_friends_for_user' do
        it "should only return #{klass.to_s.pluralize} made by friends" do
          klass.by_friends_for_user(@user).count.should == 2
        end
      end
    end
  end

  def it_should_scope_before_and_after(klass)
    context 'before/after scoping' do
      before(:each) do
        klass.destroy_all

        sym = klass.to_s.downcase.intern

        @first  = FactoryGirl.create(sym)
        @second = FactoryGirl.create(sym)
        @third  = FactoryGirl.create(sym)
      end

      describe '.before' do
        it "should only return #{klass.to_s.pluralize} before the passed id" do
          klass.before(@second.id).should == [@first]
        end
      end

      describe '.after' do
        it "should only return #{klass.to_s.pluralize} after the passed id" do
          klass.after(@second.id).should == [@third]
        end
      end

      describe '.before_or_after' do
        context 'given a Hash-like arg (params)' do
          it 'should call before if passed a hash with key :before' do
            klass.should_receive(:before).with(@second.id)
            klass.before_or_after(:before => @second.id)
          end

          it 'should call after if passed a hash with key :after' do
            klass.should_receive(:after).with(@second.id)
            klass.before_or_after(:after => @second.id)
          end

          it 'should just let everything pass through if no keys :before/:after' do
            klass.before_or_after({}).should == klass.all
          end
        end
      end
    end
  end

  def it_should_have_a_community_feed_finder(klass) 
    describe '.community_feed' do
      before(:each) do 
        klass.destroy_all

        sym = klass.to_s.downcase.intern

        @user = FactoryGirl.create(:user)

        @first  = FactoryGirl.create(sym)
        @second = FactoryGirl.create(sym)
        @third  = FactoryGirl.create(sym)
      end

      it 'should call .recent (limit 8, order, blocked users filtered)' do
        klass.should_receive :recent
        klass.community_feed(@user)
      end

      context 'with no id arg' do
        it "should return only the proper number of #{klass.to_s.pluralize}" do 
          klass.community_feed(@user).count.should == 3
        end
      end

      context 'with id arg' do
        context 'for before' do
          it "should assign only proper number of #{klass.to_s.pluralize} to @slides" do 
            klass.community_feed(@user, :before => @second.id).should == [@first]
          end
        end

        context 'for after' do
          it "should assign only proper number of #{klass.to_s.pluralize} to @slides" do 
            klass.community_feed(@user, :after => @second.id).should == [@third]
          end
        end
      end
    end

  end

  def it_should_have_a_feed_by_user_and_pagination(klass) 
    describe '.community_feed' do
      before(:each) do 
        klass.destroy_all

        sym = klass.to_s.downcase.intern

        @user = FactoryGirl.create(:user)

        FactoryGirl.create(sym, :user_id => @user.id)
        FactoryGirl.create(sym)
      end

      it 'should call .community_feed (limit 8, order, blocked users filtered via .recent)' do
        hash = {}
        klass.should_receive(:community_feed).with(@user, hash)
        klass.feed_by_user_and_pagination(@user, hash)
      end

      it 'should only return records created by the passed User' do
        klass.count.should == 2
        records = klass.feed_by_user_and_pagination(@user, {})
        records.count.should == 1
      end
    end
  end
end
