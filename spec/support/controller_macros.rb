module ControllerMacros
  def login_user
    before(:each) do
      @user = FactoryGirl.create(:user)
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      session[:user_id] = @user.id
    end
  end

  def it_should_handle_index_by_parent_id(klass, parent_klass)
    # todo factory :with_parent ? REFACTOR
    # todo 406 if no parent_id ?
    
    describe 'shared index functionality' do
      parent_str     = parent_klass.to_s.downcase
      parent_id_str = "#{parent_str}_id"

      before(:each) do
        str         = klass.to_s.downcase
        @sym        = str.intern 
        @sym_plural = str.pluralize.intern 

        @parent_sym    = parent_str.intern
        @parent_id_sym = parent_id_str.intern
      end

      context "with #{parent_id_str}" do
        it "should show #{klass.to_s.pluralize} for a #{parent_klass.to_s}" do
          @parent   = FactoryGirl.create(@parent_sym)
          @instance = FactoryGirl.create(@sym, @parent_id_sym => @parent.id)
          FactoryGirl.create(@sym, @parent_id_sym => @parent.id + 1)
          params = { @parent_id_sym => @parent.to_param }

          get :index, params, valid_session
          assigns(@sym_plural).should == [@instance]
        end
      end
    end
  end

  def it_should_handle_index_by_user(*args)
    klass = args.shift

    args = args.extract_options!

    action          = args[:action] || :index
    handles_user_id = args[:by_user_id]

    context "without parent_id and with auth" do
      it 'should use provider/uid params if passed' do
        user = FactoryGirl.create(:user)
        auth = FactoryGirl.create(:authorization, :user_id => user.id)

        get action, {:provider => auth.provider, :uid => auth.uid}, valid_session

        assigns(:user).should_not == @user
        assigns(:user).should == user
      end

      it 'should use the current user if no provider/uid is passed in' do
        get action, {}, valid_session
        assigns(:user).should == @user
      end

      if handles_user_id
        it 'should use user_id if passed in' do
          user = FactoryGirl.create(:user)
          get action, {user_id: user.to_param}, valid_session
          assigns(:user).should == user
        end
      end
    end
  end

  def it_should_handle_before_and_after_for_action_and_by_current_user(klass, action)
    context 'before_or_after' do
      before(:each) do
        klass.destroy_all

        str         = klass.to_s.downcase
        @sym        = str.intern 
        @sym_plural = str.pluralize.intern 

        # noise before
        4.times { FactoryGirl.create(@sym) }

        user_id_sym = klass == Invitation ? :invited_user_id : :user_id
        @first  = FactoryGirl.create(@sym, user_id_sym => @user.id)
        @second = FactoryGirl.create(@sym, user_id_sym => @user.id)
        @third  = FactoryGirl.create(@sym, user_id_sym => @user.id)

        # noise after
        4.times { FactoryGirl.create(@sym) }
      end

      it_should_handle_before_and_after_for_action(klass, action, false)
    end
  end

  def it_should_handle_before_and_after_for_action(klass, action, before_block_needed=true)
    ### DOESNT RUN IF before_block_needed IS FALSE ###
    ### DOESNT RUN IF before_block_needed IS FALSE ###
    before(:each) do
      klass.destroy_all

      str         = klass.to_s.downcase
      @sym        = str.intern 
      @sym_plural = str.pluralize.intern 

      @first  = FactoryGirl.create(@sym)
      @second = FactoryGirl.create(@sym)
      @third  = FactoryGirl.create(@sym)
    end if before_block_needed
    ### DOESNT RUN IF before_block_needed IS FALSE ###
    ### DOESNT RUN IF before_block_needed IS FALSE ###

    context 'handling' do
      it 'should call (limit/sort/blocked)' do
        pending
        @user.stub(@sym_plural).and_return(klass.all)
        @user.should_receive :filter_blocked
        klass.should_receive :eight_most_recent
        get action, {}, valid_session
      end

      context 'without :before/:after' do
        it "should show recent #{klass.to_s.pluralize}" do
          @user.send(@sym_plural).count.should == 3
          get action, {}, valid_session
          assigns(@sym_plural).count.should == 3
        end
      end

      context 'with :before/:after' do
        it "should return #{klass.to_s.pluralize} :before => id" do
          get action, {:before => @second.id}, valid_session
          assigns(@sym_plural).should == [@first]
        end

        it "should return #{klass.to_s.pluralize} :after => id" do
          get action, {:after => @second.id}, valid_session
          assigns(@sym_plural).should == [@third]
        end
      end
    end
  end
end
