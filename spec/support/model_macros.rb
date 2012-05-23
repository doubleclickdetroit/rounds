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
end
