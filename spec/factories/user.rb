FactoryGirl.define do

  factory :user do

    first_name "Bill"
    last_name "Ted"
    sequence(:email) { |n|
      "user#{n}@test.com"
    }
    password 'password'
    password_confirmation 'password'

    agree_to_tc true

    factory :admin do
      disable_admin true
      role :admin
    end

    factory :cause do
      role :cause
      sequence(:company_name) { |n|
        "Cause#{n}"
      }
      description "I am a cause"
      summary "I"
    end

    factory :business do
      role :business
      access_code '1234'
      sequence(:company_name) { |n|
        "Business#{n}"
      }
      description "I make money as a business"
      summary "Make money"
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