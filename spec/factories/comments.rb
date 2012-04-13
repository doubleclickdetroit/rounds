# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    slide nil
    text 'Lorem ipsum dolor sit amet'
  end
end
