require 'spec_helper'

describe Picture do
  before(:each) do
    @pic = FactoryGirl.create(:picture, :with_file)
    @url = @pic.file.url
  end

  subject { @pic }
  it { should be_a_kind_of(Slide) }

  describe '.content' do
    it 'should return a file path to the associated image' do
      @pic.content.should == @url
    end
  end

  describe '#get_aws_credentials' do
    it 'should return valid AWS credentials for upload'
  end
end
