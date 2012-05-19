FactoryGirl.define do
  factory :round do
    sequence(:user_id) {|n| n}
  end
end
