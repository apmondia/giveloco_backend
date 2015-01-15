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

    sequence(:company_name) { |n|
      "CompanyName#{n}"
    }

    factory :cause do
      role :cause
      description "I am a cause"
      summary "I"
    end

    factory :business do
      role :business
      access_code '1234'
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

    sponsorship_rate '20'

  end

end