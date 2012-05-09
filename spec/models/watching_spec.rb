require 'spec_helper'

describe Watching do
  before(:each) do
    @watching = Factory(:watching)
  end

  describe '.round_lock' do
    it 'should return the associated RoundLock' do                  
      @round = Factory(:round)
      @watching = Factory(:watching, :round_id => @round.id)
      @lock = Factory(:round_lock, :round_id => @round.id) 
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

end
