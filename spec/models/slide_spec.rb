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
end
