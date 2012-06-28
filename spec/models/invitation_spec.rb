require 'spec_helper'

describe Invitation do
  context '' do
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

      it 'should send a push notification to invited user' do
        pending 'not receiving message. also, not really finished.'
        @user       = FactoryGirl.create(:user)
        @round      = FactoryGirl.create(:round)
        @invitation = FactoryGirl.create(:invitation, invited_user_id: @user, round: @round)
        PrivatePub.should_receive(:publish_to) # .with("/api/users/#{@user.id}/invitations", {message: 'New invitation received.'})
      end
    end

    klass = Invitation

    it_should_have_a_creator(klass)

    it_should_scope_recent(klass)

    it_should_scope_friends(klass)

    it_should_scope_before_and_after(klass)

  end

  describe 'validation' do
    before(:each) do
      @owner      = FactoryGirl.create(:user)
      @publ_round = FactoryGirl.create(:round, :private => false, user: @owner)
      @priv_round = FactoryGirl.create(:round, :private => true,  user: @owner)
      @other_user = FactoryGirl.create(:user)
    end

    it 'should allow any user to invite someone to a public round' do
      expect {
        FactoryGirl.create :invitation, user: @owner,      round: @publ_round 
        FactoryGirl.create :invitation, user: @other_user, round: @publ_round 
      }.to change(Invitation, :count).by(2)
    end

    it 'should not allow a user who is not the round creator to invite someone to a private round' do
      expect {
        FactoryGirl.create :invitation, user: @other_user, round: @priv_round
      }.should raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should allow a user who is the round creator to invite someone to a private round' do
      expect {
        FactoryGirl.create :invitation, user: @owner,      round: @priv_round 
      }.to change(Invitation, :count).by(1)
    end
  end
end
