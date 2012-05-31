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

  describe 'before_destroy callbacks' do
    it 'should call send_push_notification' do
      @round = FactoryGirl.create(:round)
      @watching = FactoryGirl.create(:watching, :round_id => @round.id)
      @watching.round = @round
      PrivatePub.should_receive(:publish_to).with("/api/rounds/#{@round.id}/watch", message: "Round #{@round.id} is unlocked!")
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

describe Dib do
end
