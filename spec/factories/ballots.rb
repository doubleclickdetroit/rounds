FactoryGirl.define do
  factory :ballot do
    slide { FactoryGirl.create(:slide) }
    user_id 0
    vote 1
  end
end
