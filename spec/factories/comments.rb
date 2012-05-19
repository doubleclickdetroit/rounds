FactoryGirl.define do
  factory :comment do
    sequence(:user_id) {|n| n}
    slide nil
    text 'Lorem ipsum dolor sit amet'
  end
end
