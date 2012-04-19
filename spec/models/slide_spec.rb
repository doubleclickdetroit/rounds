require 'spec_helper'

describe Slide do
  before(:each) do
    @slide = Factory(:slide) 

    @round = Factory(:round)
    @round.slides << @slide 

    @slide.comments << Factory(:comment)
    @slide.comments << Factory(:comment)
  end

  it 'should belong to a Round' do
    @slide.round.should == @round
  end

  it 'should have many Comments' do
    @slide.comments.all? do |comment|
      comment.instance_of?(Comment)
    end.should be_true
  end

  describe '.to_hash' do
    before(:each) do
      @slide.stub(:content).and_return('')
      @hash = @slide.to_hash 
    end

    keys = %w[type id round_id created_at updated_at content]
    keys.each do |key|
      it "should return a Hash containing #{key}" do
        @hash.should have_key(key)
      end
    end

    it 'should have no other keys' do
      (@hash.keys && keys).should == @hash.keys
    end
  end

  describe '.to_json' do
    it 'should call Slide.to_hash' do
      @slide.should_receive :to_hash
      @slide.to_json
    end

    it 'should call .to_json on Slide.to_hash' do
      @slide.stub(:to_hash).and_return({})
      Hash.any_instance.should_receive :to_json
      @slide.to_json
    end
  end

  describe 'after_create' do
    it 'should assign a position of 0 if it is the first Slide in the Round' do
      @round.slides = []
      slide = Factory.build(:slide, :round_id => @round.to_param)
      slide.position.should be_nil
      slide.save
      slide.position.should == 0
    end

    it 'should assign a position one greater than the last Slide in the Round' do
      slide = Factory.build(:slide, :round_id => @round.to_param)
      slide.position.should be_nil
      slide.save
      slide.position.should == 1
    end
  end

  describe '.created_by' do
    pending 'do i need to check this more thoroughly here or just in the controller spec?'

    it 'should return a User' do
      @slide.created_by = Factory(:user)
      @slide.created_by.should be_an_instance_of(User)
    end
  end

  describe '.creator' do
    it 'should simply call .created_by' do
      @slide.should_receive :created_by
      @slide.creator
    end
  end

end
