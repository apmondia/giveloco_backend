# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :certificate do
    association :purchaser, :factory => :user
    sponsorship
    donation_percentage "9.99"
    amount 9.99
    recipient "happyuser@fake.com"
    stripeToken 'fakeStripeToken'
    disable_charge true
  end
end
