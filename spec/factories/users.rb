FactoryGirl.define do
  factory :user do
    sequence(:id)  {|n| n}
    sequence(:name) {|n| "User Name #{n}"}
  end
end
