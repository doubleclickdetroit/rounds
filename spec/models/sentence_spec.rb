require 'spec_helper'

describe Sentence do
  before(:each) do
    @sent  = Factory(:sentence)
    @round = @round
  end

  subject { @sent }
  it { should be_a_kind_of(Slide) }
end
