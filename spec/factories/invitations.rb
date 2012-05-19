FactoryGirl.define do
  factory :invitation do
    user_id '1'
    invited_user_id '1'
    round { FactoryGirl.create(:round) }
    accepted false
  end
end
