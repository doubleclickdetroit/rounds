require 'spec_helper'

describe Invitation do
  before(:each) do
    @invitation = Factory(:invitation)
  end

  describe '.round' do
    it 'should return a Round' do
      @invitation.round = Factory(:round)
      @invitation.round.should be_an_instance_of(Round)
    end
  end

  it 'should have an .invitee, maybe?'

  describe '.created_by' do
    it 'should return a User' do
      @invitation.created_by = Factory(:user)
      @invitation.created_by.should be_an_instance_of(User)
    end
  end

  describe '.creator' do
    it 'should simply call .created_by' do
      @invitation.should_receive :created_by
      @invitation.creator
    end
  end
end
