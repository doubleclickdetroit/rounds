FactoryGirl.define do
  factory :round_lock do
    round_id 1
    sequence(:user_id) {|n| n}
  end
end
