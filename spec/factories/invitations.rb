FactoryGirl.define do
  factory :invitation do
    fid '1'
    invited_fid '1'
    round { FactoryGirl.create(:round) }
    accepted false
  end
end
