FactoryGirl.define do
  factory :invitation do
    sequence(:user_id) {|n| n}
    sequence(:invited_user_id) {|n| n}
    round { FactoryGirl.create(:round) }
    accepted false
  end
end
