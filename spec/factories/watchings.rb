FactoryGirl.define do
  factory :watching do
    round_id 1
    sequence(:user_id) {|n| n}
  end
end
