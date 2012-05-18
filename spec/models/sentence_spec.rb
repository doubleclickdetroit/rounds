require 'spec_helper'

describe Sentence do
  before(:each) do
    @sent = FactoryGirl.create(:sentence)
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
end
