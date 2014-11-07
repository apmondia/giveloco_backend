FactoryGirl.define do

  factory :user do

    first_name "Bill"
    last_name "Ted"
    sequence(:email) { |n|
      "user#{n}@test.com"
    }
    password 'password'
    password_confirmation 'password'

    factory :admin do
      role :admin
    end

    factory :cause do
      role :cause
    end

    factory :business do
      role :business
    end

    sequence(:authentication_token) { |n|
      "token#{n}"
    }

    after(:create) do |user|
      user.skip_confirmation!
    end

  end

end