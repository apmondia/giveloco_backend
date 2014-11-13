# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sponsorship do
    business
    cause
    donation_percentage "9.99"
    status :pending
  end
end
