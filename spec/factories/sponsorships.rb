# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sponsorship do
    from_user nil
    to_user nil
    status 1
    donation_percentage "9.99"
  end
end
