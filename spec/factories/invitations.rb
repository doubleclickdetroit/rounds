FactoryGirl.define do
  factory :invitation do
    user_id 0
    invited_user_id 0 
    round { FactoryGirl.create(:round) }
    read false
  end
end
