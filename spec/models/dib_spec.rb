require 'spec_helper.rb'

describe Dib do
  context 'before_destroy callbacks' do
    describe 'send_push_notification' do
      it 'should send a push notification to the user' do
        @round = FactoryGirl.create(:round)
        @watching = FactoryGirl.create(:dib, :round_id => @round.id)
        @watching.round = @round
        PrivatePub.should_receive(:publish_to).with("/api/rounds/#{@round.id}/dib", message: "Round #{@round.id} is unlocked! Your turn!")
        @watching.destroy
      end
    end
  end

  it 'should have a cost (coins/points/etc)'
end
