FactoryGirl.define do

  factory :user do

    first_name "Bill"
    last_name "Ted"
    sequence(:email) { |n|
      "user#{n}@test.com"
    }
    password 'password'
    password_confirmation 'password'

    factory :cause do
      role :cause
    end

    factory :business do
      role :business
    end

    after(:create) do |user|
      user.skip_confirmation!
    end

  end

end