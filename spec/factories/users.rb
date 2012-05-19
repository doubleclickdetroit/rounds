FactoryGirl.define do
  factory :user do
    sequence(:user_id)  {|n| n.to_s}
    sequence(:name) {|n| "User Name #{n}"}
  end
end
