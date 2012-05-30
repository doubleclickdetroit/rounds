require 'spec_helper'

describe RoundLock do
  before(:each) do
    @round = FactoryGirl.create(:round)
    @lock  = FactoryGirl.create(:round_lock, :round_id => @round.id)
    @num_of_watchings = 3
    @num_of_watchings.times { @lock.round.watchings << FactoryGirl.create(:watching, :round_id => @lock.round_id) }
  end

  describe '.creator' do
    it 'should return a User' do
      user = FactoryGirl.create(:user)
      @lock.user = user
      @lock.save
      @lock.reload.creator.should == user
      @lock.creator.id.should == user.id
    end
  end

  describe 'before_destroy callbacks' do
    it 'should send push notifications to those viewing the Round' do
      @lock.destroy
      PrivatePub.should_receive(:publish_to).with("/api/rounds/#{@round.id}/lock", locked: true)
      FactoryGirl.create(:round_lock, :round_id => @round.id)
    end
  end

  describe 'before_destroy callbacks' do
    it 'should destroy all watchings' do
      @lock.round.watchings.count.should == @num_of_watchings

      expect {
        @lock.destroy
      }.to change(Watching, :count).by(-@num_of_watchings)
    end

    it 'should send push notifications to those viewing the Round' do
      PrivatePub.should_receive(:publish_to).with("/api/rounds/#{@round.id}/lock", locked: false)
      @lock.destroy
    end
  end

  it 'should have many Watchings' do
    @round.watchings.all? do |watching|
      watching.instance_of?(Watching)
    end.should be_true
  end

end
