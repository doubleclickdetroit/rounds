require 'spec_helper'

describe RoundLock do
  before(:each) do
    @round = FactoryGirl.create(:round)
    @lock  = FactoryGirl.create(:round_lock, :round_id => @round.id)
    @num_of_watchings = 3
    @num_of_watchings.times { @lock.watchings << FactoryGirl.create(:watching, :round_id => @lock.round_id) }
  end

  describe 'before_destroy callbacks' do
    it 'should destroy all watchings' do
      @lock.watchings.count.should == @num_of_watchings

      expect {
        @lock.destroy
      }.to change(Watching, :count).by(-@num_of_watchings)
    end
  end

  it 'should have many Watchings' do
    @round.watchings.all? do |watching|
      watching.instance_of?(Watching)
    end.should be_true
  end

end
