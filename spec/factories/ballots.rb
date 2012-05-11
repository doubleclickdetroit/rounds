FactoryGirl.define do
  factory :ballot do
    slide { Factory(:slide) }
    sequence(:fid) {|n| n} 
    vote 1
  end
end
