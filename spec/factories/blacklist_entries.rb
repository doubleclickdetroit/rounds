FactoryGirl.define do
  factory :blacklist_entry do
    user nil
    sequence(:user_id) {|n| n}
    sequence(:blocked_user_id) {|n| n+1}
  end
end
