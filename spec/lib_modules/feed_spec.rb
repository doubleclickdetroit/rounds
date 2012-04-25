require 'spec_helper'
require Rails.root.join('lib','modules','feed.rb')

describe Feed do

  describe '#recent' do
    before(:each) do
      20.times { Factory(:round) }
      20.times { Factory(:slide) }
      20.times { Factory(:comment) }
    end

    it 'should return 10 results' do
      pending
      Feed.recent.count.should == 10
    end
  end

  describe '#whats_hot' do
    pending 'defining algorithm for this'
  end

  describe '#activity' do
    pending 'creation of this method in lib/modules/common.rb'
  end

  describe '#friends_activity' do
    pending
  end

end
