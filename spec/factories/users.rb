FactoryGirl.define do
  factory :user do
    sequence(:fid)  {|n| n.to_s}
    sequence(:name) {|n| "User Name #{n}"}
  end
end
