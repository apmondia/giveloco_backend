# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sponsorship do
    business
    cause
    status 1
    donation_percentage "9.99"
  end
end
