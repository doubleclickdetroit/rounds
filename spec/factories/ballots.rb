# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ballot do
    slide { Factory(:slide) }
    fid 1
    vote 1
  end
end
