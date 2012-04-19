FactoryGirl.define do
  factory :user do
    # sequence(:first) {|n|"Foo#{n}"}
    # sequence(:last) {|n|"Bar#{n}"}

    sequence(:email) {|n|"foo#{n}@bar.com"}

    password "foobarbaz"
    password_confirmation {|u| u.password}

    sequence(:fid) {|n|n}
  end
end
