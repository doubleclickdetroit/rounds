FactoryGirl.define do
  factory :ballot do
    slide { FactoryGirl.create(:slide) }
    sequence(:fid) {|n| n.to_s} 
    vote 1
  end
end
