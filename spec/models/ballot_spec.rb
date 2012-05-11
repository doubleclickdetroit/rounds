require 'spec_helper'

describe Ballot do
  before(:each) do
    # @user   = Factory(:user)
    # @slide  = Factory(:slide)
    @ballot = Factory(:ballot)
  end

  pending 'validation (e.g. votes between X and Y)'

  describe '.created_by' do
    it 'should return a User' do
      @ballot.created_by = Factory(:user)
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
      slide = Factory(:slide)
      @ballot.slide = slide
      @ballot.save
      @ballot.reload.slide.should == slide
    end
  end

  describe '.before_validation' do
    let(:slide) { Factory(:slide) }

    (1..5).each do |num|
      it "should pass with a vote val of #{num}" do
        expect {
          Factory(:ballot, :slide_id => slide.id, :vote => num)
        }.to change(Ballot, :count).by(1)
      end
    end

    [0,6].each do |num|
      it "should fail with a vote val of #{num}" do
        expect {
          Factory(:ballot, :slide_id => slide.id, :vote => num)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '.after_create' do
    it "should update the Slide's vote count" do
      slide = Factory(:slide)
      slide.votes.should == 0
      Factory(:ballot, :slide_id => slide.id, :vote => 3)
      slide.reload.votes.should == 3
    end
  end

end
