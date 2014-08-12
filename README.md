Taliflo API
===============

Taliflo API built with Ruby on Rails using Grape.

All API controller files are located in the ```app/api``` directory. The application structure is meant to be modular and version controlled. The base application API structure looks like this:

```
/app
--- /api
------ /v1
--------- base.rb
--------- defaults.rb
--------- /users
------------ entities.rb
------------ users.rb
------ api.rb
```

The ```app/api/v1/defaults.rb``` file is where all common configuration is done for the API (including HTTP Headers).

### Core Components / Gems

- Ruby v2.1.2
- Rails v4.1.1
- Grape
- Grape-Entities
- Seedbank


### Installation Notes

1) Make sure to install the Figaro gem (included in the Gemfile) by running ```rails generate figaro:install``` in terminal. (Refer to this github URL for more info regarding Figaro: https://github.com/laserlemon/figaro/tree/0-stable)

The ```config/application.yml``` file will automatically be added to the ```.gitignore``` file for security reasons.


### Working with the API
The API uses the Devise gem for user authentication, and thus CRUD commands follow a different URI convention than the rest of the API. The User resource paths only allow GET requests through the API. All other CRUD requests for users should be done through the following paths:

```
 POST        /user/login(.:format)            user/sessions#create
 DELETE      /user/logout(.:format)           user/sessions#destroy
 POST        /user/signup(.:format)           user/registrations#create

 GET         /user/cancel(.:format)           user/registrations#cancel
 GET         /user/sign_up(.:format)          user/registrations#new
 GET         /user/edit(.:format)             user/registrations#edit
 PATCH       /user(.:format)                  user/registrations#update
 PUT         /user(.:format)                  user/registrations#update
 DELETE      /user(.:format)                  user/registrations#destroy

 POST        /user/password(.:format)         user/passwords#create
 GET         /user/password/new(.:format)     user/passwords#new
 GET         /user/password/edit(.:format)    user/passwords#edit
 PATCH       /user/password(.:format)         user/passwords#update
 PUT         /user/password(.:format)         user/passwords#update

 POST        /user/confirmation(.:format)     user/confirmations#create
 GET         /user/confirmation/new(.:format) user/confirmations#new
 GET         /user/confirmation(.:format)     user/confirmations#show
```

The full list of API routes can be accessed from the command line using ```rake api:routes```, but if the command line is not available, the complete list is as follows (note the "/v1" prefix):

```
# Users
 GET        /v1/users(.:format)
 GET        /v1/users/:id(.:format)

 GET        /v1/users/:id/transactions_created(.:format)
 GET        /v1/users/:id/transactions_created/:trans_id(.:format)
 GET        /v1/users/:id/transactions_accepted(.:format)
 GET        /v1/users/:id/transactions_accepted/:trans_id(.:format)

 GET        /v1/users/:id/vouchers_issued(.:format)
 GET        /v1/users/:id/vouchers_issued/:voucher_id(.:format)
 GET        /v1/users/:id/vouchers_claimed(.:format)
 GET        /v1/users/:id/vouchers_claimed/:voucher_id(.:format)

 GET        /v1/users/:id/redemptions(.:format)
 GET        /v1/users/:id/redemptions/:voucher_id(.:format)

# Transactions
 GET        /v1/transactions(.:format)
 GET        /v1/transactions/:id(.:format)
 POST       /v1/transactions(.:format)
 PUT        /v1/transactions/:id(.:format)

 # Vouchers
 GET        /v1/vouchers(.:format)
 GET        /v1/vouchers/:id(.:format)
 POST       /v1/vouchers(.:format)
 PUT        /v1/vouchers/:id(.:format)

 # Redemptions
 GET        /v1/redemptions(.:format)
 GET        /v1/redemptions/:id(.:format)
 POST       /v1/redemptions(.:format)
```

The DELETE method has been removed from the API to prevent accidental deletion of database fields.

A User's JSON data looks like this:

```
{
  "id": 3,
  "role": "business",
  "email": "destini_gleason@boehm.biz",
  "first_name": "Isaias",
  "last_name": "Balistreri",
  "company_name": "Cassin, Feest and Mohr",
  "street_address": "13099 Javier Passage",
  "city": "Wuckertside",
  "state": "Oklahoma",
  "country": "CA",
  "zip": "59783-4561",
  "tags": [
    "sapiente",
    "illo",
    "eius",
    "excepturi",
    "nam"
  ],
  "summary": "Voluptas deleniti non est voluptatem delectus maiores.",
  "description": "Dolor deleniti nemo.",
  "website": "http://www.example.com/carolanne",
  "balance": "2917.13",
  "total_debits": 11,
  "total_debits_value": "2679.96",
  "total_credits": 3,
  "total_credits_value": "1750.82",
  "is_featured": true,
  "supporters": [1, 2, 3, 4, 5],        # Lists user IDs
  "supported_causes": [1, 2, 3, 4, 5],  # Lists user IDs
  "transactions_created": [
    {
      "id": 11,
      "created_by_id": 71,
      "accepted_by_id": 58,
      "trans_id": 11,
      "trans_type": "donation",
      "from_name": "Mona Koss",
      "to_name": "Johnston-Walter",
      "total_debt": "3195.44",
      "total_credit": "1156.0",
      "remaining_debt": "-2039.44",
      "status": "cancelled",
      "active": true,
      "created_at": "2014-08-11T21:57:13.850Z",
      "updated_at": "2014-08-11T21:57:13.850Z"
    }
  ],
  "transactions_accepted": [

  ],
  "vouchers_issued": [

  ],
  "vouchers_claimed": [
    {
      "id": 5,
      "issued_by_id": 32,
      "issued_by_name": "Beer-Lowe",
      "claimed_by_id": 71,
      "claimed_by_name": "Jamaal Green V",
      "max_value": "22.49",
      "redeemed": false,
      "created_at": "2014-08-11T21:57:21.140Z",
      "updated_at": "2014-08-11T21:57:21.140Z"
    }
  ],
  "redemptions": [
    {
      "id": 11,
      "voucher_id": 5,
      "redeemed_by_id": 78,
      "redeemer_name": "Mrs. Pauline Pagac",
      "vendor_id": 7,
      "vendor_name": "Kub, Mitchell and Waelchi",
      "value": "3.32",
      "created_at": "2014-08-11T21:57:13.756Z",
      "updated_at": "2014-08-11T21:57:13.756Z"
    }
  ],
  "created_at": "2014-08-11T21:57:19.701Z",
  "updated_at": "2014-08-11T21:57:19.701Z",
  "last_sign_in_at": null,
  "deleted_at": null
}
```


### API Notes

https://github.com/Apipie/apipie-rails

Apipie is included in the Gemfile but commented out. It is included for the eventual documentation of the API.

To see all API routes, run the following commend in terminal from your application directory: ```rake api:routes```
