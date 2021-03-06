require 'spec_helper'

describe Ballot do
  before(:each) do
    # @user   = FactoryGirl.create(:user)
    # @slide  = FactoryGirl.create(:slide)
    @ballot = FactoryGirl.create(:ballot)
  end

  pending 'validation (e.g. votes between X and Y)'

  describe '.created_by' do
    it 'should return a User' do
      @ballot.created_by = FactoryGirl.create(:user)
      @ballot.created_by.should be_an_instance_of(User)
    end
  end

  describe '.creator' do
    it 'should simply call .created_by' do
      @ballot.should_receive :created_by
      @ballot.creator
    end
  end

  describe '.slide' do
    it 'should return associate a Slide' do
      slide = FactoryGirl.create(:slide)
      @ballot.slide = slide
      @ballot.save
      @ballot.reload.slide.should == slide
    end
  end

  describe 'validation' do
    let(:slide) { FactoryGirl.create(:slide) }

    [:vote, :user_id].each do |att|
      it "should validate the presence of #{att}" do
        expect {
          FactoryGirl.create(:ballot, att => nil)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    (1..5).each do |num|
      it "should pass with a vote val of #{num}" do
        expect {
          FactoryGirl.create(:ballot, :slide_id => slide.id, :vote => num)
        }.to change(Ballot, :count).by(1)
      end
    end

    [0,6].each do |num|
      it "should fail with a vote val of #{num}" do
        expect {
          FactoryGirl.create(:ballot, :slide_id => slide.id, :vote => num)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    it 'should not allow a second Ballot to be created by the same user_id for a Slide' do
      user_id = 1
      slide = FactoryGirl.create(:slide)
      FactoryGirl.create(:ballot, :slide_id => slide.id, :user_id => user_id)

      expect {
        FactoryGirl.create(:ballot, :slide_id => slide.id, :user_id => user_id)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '.after_create' do
    it "should update the Slide's vote count" do
      slide = FactoryGirl.create(:slide)
      slide.votes.should == 0
      FactoryGirl.create(:ballot, :slide_id => slide.id, :vote => 3)
      slide.reload.votes.should == 3
    end
  end

  klass = Ballot

  it_should_have_a_creator(klass)

  it_should_scope_recent(klass)

  it_should_scope_friends(klass)

  it_should_scope_before_and_after(klass)

end
