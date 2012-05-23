module ModelMacros
  def it_should_have_a_creator(klass)
    before(:each) do
      user = FactoryGirl.create(:user)

      @instance = FactoryGirl.create(klass.to_s.downcase.intern) 
      @instance.user = user
      @instance.save
      @instance.reload
    end

    context 'belongs to a User' do
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
      describe '.by_friends_for_user' do
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

        it 'should only return Rounds made by friends' do
          klass.by_friends_for_user(@user).count.should == 2
        end
      end
    end
  end
end
