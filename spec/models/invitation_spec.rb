require 'spec_helper'

describe Invitation do
  before(:each) do
    @invitation = FactoryGirl.create(:invitation)
  end

  describe '.round' do
    it 'should return a Round' do
      @invitation.round = FactoryGirl.create(:round)
      @invitation.round.should be_an_instance_of(Round)
    end
  end

  it 'should have an .invitee, maybe?'

  describe '.created_by' do
    it 'should return a User' do
      @invitation.created_by = FactoryGirl.create(:user)
      @invitation.created_by.should be_an_instance_of(User)
    end
  end

  describe '.creator' do
    it 'should simply call .created_by' do
      @invitation.should_receive :created_by
      @invitation.creator
    end
  end

  describe '#private' do
    before(:each) do
      round       = FactoryGirl.create(:round, :private => false)
      @public_inv = FactoryGirl.create(:invitation, round: round)

      round        = FactoryGirl.create(:round, :private => true)
      @private_inv = FactoryGirl.create(:invitation, round: round)
    end

    it 'should scope only Invitations that are private' do
      Invitation.private.should == [@private_inv]
    end
  end

  describe '- After Create Callbacks -' do
    pending 'should probably be done before_create'

    it 'should set private to false if it is not to a private Round' do
      @round      = FactoryGirl.create(:round, :private => false)
      @invitation = FactoryGirl.create(:invitation, round: @round)
      @invitation.private.should be_false
    end

    it 'should set private to true if it is to a private Round' do
      @round      = FactoryGirl.create(:round, :private => true)
      @invitation = FactoryGirl.create(:invitation, round: @round)
      @invitation.private.should be_true
    end
  end

  klass = Invitation

  it_should_have_a_creator(klass)

  it_should_scope_recent(klass)

  it_should_scope_friends(klass)

  it_should_scope_before_and_after(klass)

end
