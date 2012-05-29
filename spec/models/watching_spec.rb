require 'spec_helper'

describe Watching do
  before(:each) do
    @watching = FactoryGirl.create(:watching)
  end

  describe '.round_lock' do
    it 'should return the associated RoundLock' do                  
      @round = FactoryGirl.create(:round)
      @watching = FactoryGirl.create(:watching, :round_id => @round.id)
      @lock = FactoryGirl.create(:round_lock, :round_id => @round.id) 
      @watching.round_lock = @lock
      @watching.reload.round_lock.should == @lock
    end                                                             

    it 'should have no more than one RoundLock'                     
  end    

  describe 'before_destroy callbacks' do
    it 'should call send_push_notification' do
      @watching.should_receive :send_push_notification
      @watching.destroy
    end

    it 'should send a push notification to the user'
  end

  klass = Watching

  it_should_have_a_creator(klass)

  it_should_scope_recent(klass)

  it_should_scope_friends(klass)

  it_should_scope_before_and_after(klass)

end
