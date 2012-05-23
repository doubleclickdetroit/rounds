module ModelMacros
  def it_should_have_a_creator(klass)
    context 'belongs to a User' do
      before(:each) do
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
        9.times { FactoryGirl.create(klass.to_s.downcase.intern) }
      end

      describe '.recent' do
        pending 'test recent? not just limit 8?'

        it 'should return the 8 most recent Rounds' do
          klass.recent.count.should == 8
        end
      end
    end
  end

  def it_should_scope_friends(klass)
    context 'friend scoping' do
      before(:each) do
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
        it 'should only return Rounds made by friends' do
          klass.by_friends_for_user(@user).count.should == 2
        end
      end
    end
  end

  def it_should_scope_before_and_after(klass)
    context 'before/after scoping' do
      before(:each) do
        sym = klass.to_s.downcase.intern
      end

      describe '.before' do
        it 'should spec before'

        # describe '.before' do
        #   it 'should only return Slides created before a specific Time' do
        #     time = Time.now

        #     # todo wasteful
        #     Slide.destroy_all

        #     slide1 = FactoryGirl.create(:slide, :created_at => time-1)
        #     slide2 = FactoryGirl.create(:slide, :created_at => time+1)

        #     Slide.count.should == 2
        #     Slide.before(time).count.should == 1

        #   end
        #   pending 'actual test of time'
        # end
      end

      describe '.after' do
        it 'should spec after'
      end
    end
  end
end
