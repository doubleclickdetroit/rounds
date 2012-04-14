require 'spec_helper'

describe Sentence do
  before(:each) do
    @sent  = Factory(:sentence)
    @round = @round
  end

  subject { @sent }
  it { should be_a_kind_of(Slide) }

  describe '.content' do
    before(:each) do
      @text = "multiline\ntext"
      @sent.text = @text 
    end

    it 'should return multiline text' do
      @sent.content.should == @text
    end
  end

  describe '.to_hash' do
    let(:hash) { @sent.send :to_hash }
    keys = %w[id round_id created_at updated_at content]
    keys.each do |key|
      it "should return a Hash containing #{key}" do
        hash.should have_key(key)
      end
    end
  end
end
