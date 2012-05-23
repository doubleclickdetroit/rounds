module ControllerMacros
  def login_user
    before(:each) do
      @user = FactoryGirl.create(:user)
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      session[:user_id] = @user.id
    end
  end

  def it_should_handle_index_by_parent_id_or_by_user(klass, parent_klass)
    # todo factory :with_parent ?
    
    describe 'shared index functionality' do
      before(:each) do
        str         = klass.to_s.downcase
        @sym        = str.intern 
        @sym_plural = str.pluralize.intern 

        parent_str     = parent_klass.to_s.downcase
        @parent_sym    = parent_str.intern
        @parent_id_sym = "#{parent_str}_id".intern
      end

      # by parent
      context "with #{@parent_id_sym}" do
        it "should show #{klass.to_s.pluralize} for a #{parent_klass.to_s}" do
          @parent   = FactoryGirl.create(@parent_sym)
          @instance = FactoryGirl.create(@sym, @parent_id_sym => @parent.id)
          FactoryGirl.create(@sym, @parent_id_sym => @parent.id + 1)
          params = { @parent_id_sym => @parent.to_param }

          get :index, params, valid_session
          assigns(@sym_plural).should == [@instance]
        end
      end

      #todo call by user
      it_should_handle_index_by_user(klass)
    end
  end

  def it_should_handle_index_by_user(klass)
    context "without #{@parent_id_sym} and with user id" do
      before(:each) do
        klass.destroy_all

        # noise before
        4.times { FactoryGirl.create(@sym) }

        @first  = FactoryGirl.create(@sym, :user_id => @user.id)
        @second = FactoryGirl.create(@sym, :user_id => @user.id)
        @third  = FactoryGirl.create(@sym, :user_id => @user.id)

        # noise after
        4.times { FactoryGirl.create(@sym) }
      end

      it 'should use provider/uid params if passed' do
        user = FactoryGirl.create(:user)
        auth = FactoryGirl.create(:authorization, :user_id => user.id)

        get :index, {:provider => auth.provider, :uid => auth.uid}, valid_session

        assigns(:user).should_not == @user
        assigns(:user).should == user
      end

      it 'should use the current users id if no user_id is passed in' do
        get :index, {}, valid_session
        assigns(:user).should == @user
      end

      context 'and without :before/:after' do
        it "should show recent #{klass.to_s.pluralize}" do
          get :index, {}, valid_session
          assigns(@sym_plural).count.should == 3
        end
      end

      context 'with :before/:after' do
        it "should return #{klass.to_s.pluralize} :before => id" do
          get :index, {:before => @second.id}, valid_session
          assigns(@sym_plural).should == [@first]
        end

        it "should return #{klass.to_s.pluralize} :after => id" do
          get :index, {:after => @second.id}, valid_session
          assigns(@sym_plural).should == [@third]
        end
      end
    end
  end
end
