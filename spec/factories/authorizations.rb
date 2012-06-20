FactoryGirl.define do
  factory :authorization do
    provider "provider_string"
    sequence(:uid) {|n| "12341234#{n}"}
    user_id 0
  end
end
