require 'spec_helper'

describe Picture do
  before(:each) do
    @pic   = Factory(:picture)
    @round = @round
  end

  subject { @pic }
  it { should be_a_kind_of(Slide) }

  describe '.content' do
    before(:each) do
      @pic = Factory(:picture, :with_file)
      @url = @pic.file.url
    end

    it 'should return a file path to the associated image' do
      @pic.content.should == @url
    end
  end
end
