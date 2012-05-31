require 'spec_helper'

describe Watching do
  describe '.round' do
    it 'should return the associated RoundLock' do                  
      @round = FactoryGirl.create(:round)
      @watching = FactoryGirl.create(:watching, :round_id => @round.id)
      @watching.round = @round
      @watching.reload.round.should == @round
    end                                                             

    it 'should have no more than one RoundLock'                     
  end    

  context 'before_destroy callbacks' do
    describe 'send_push_notification' do
      it 'should send a push notification to the user' do
        @round = FactoryGirl.create(:round)
        @watching = FactoryGirl.create(:watching, :round_id => @round.id)
        @watching.round = @round
        PrivatePub.should_receive(:publish_to).with("/api/rounds/#{@round.id}/watch", message: "Round #{@round.id} is unlocked!")
        @watching.destroy
      end
    end
  end

  klass = Watching

  it_should_have_a_creator(klass)

  it_should_scope_recent(klass)

  it_should_scope_friends(klass)

  it_should_scope_before_and_after(klass)

end
