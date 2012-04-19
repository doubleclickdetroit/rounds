require 'spec_helper'

describe User do
  before(:each) do
    @user = Factory(:user)
  end

  describe '.rounds' do
    it 'should return an array of Rounds' do
      @round = Factory(:round)
      @user.rounds << @round
      @user.rounds.should == [@round]
    end
  end
end
