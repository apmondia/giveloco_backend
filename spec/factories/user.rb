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
      disable_admin true
      role :admin
    end

    factory :cause do
      role :cause
      sequence(:company_name) { |n|
        "Cause#{n}"
      }
      is_activated true
      is_published true
    end

    factory :business do
      role :business
      sequence(:company_name) { |n|
        "Business#{n}"
      }
      is_activated true
      is_published true
    end

    role :individual

    sequence(:authentication_token) { |n|
      "token#{n}"
    }

    after(:create) do |user|
      user.skip_confirmation!
    end

  end

end