include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :slide do
    # todo this is awful
    round { @round ? @round : FactoryGirl.build(:round) }
    fid 1
    position nil

    factory :sentence, :class => ::Sentence do
      type 'Sentence'
      sequence(:text) {|n| "Sentence Text ##{n} from FactoryGirl"}
    end

    factory :picture, :class => ::Picture do
      type 'Picture'
      trait :with_file do
        file fixture_file_upload(Rails.root.join('test','fixtures','images','image.png'), 'image/png')
      end
    end
  end
end
