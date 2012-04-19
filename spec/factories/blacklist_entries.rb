# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :blacklist_entry do
    user nil
    user_fid 1
    blocked_fid 1
  end
end
