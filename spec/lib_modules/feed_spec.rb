require 'spec_helper'
require Rails.root.join('lib','modules','feed.rb')

describe Feed do

  describe '#recent' do
    before(:each) do
      3.times { FactoryGirl.create(:round) }
      3.times { FactoryGirl.create(:slide) }
      3.times { FactoryGirl.create(:comment) }
      3.times { FactoryGirl.create(:round) }
      3.times { FactoryGirl.create(:slide) }
      3.times { FactoryGirl.create(:comment) }
    end

    it 'should return 10 results' do
      Feed.recent.count.should == 10
    end

    it 'should sort the results properly'
    it 'should take time parameter'
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
