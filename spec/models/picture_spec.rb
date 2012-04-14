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

  describe '.to_hash' do
    let(:hash) { @pic.send :to_hash }
    keys = %w[id round_id created_at updated_at content]
    keys.each do |key|
      it "should return a Hash containing #{key}" do
        hash.should have_key(key)
      end
    end
  end
end
