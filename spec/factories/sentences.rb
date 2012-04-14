# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sentence do
    sequence(:text) {|n| "Sentence Text ##{n} from FactoryGirl"}
  end
end
