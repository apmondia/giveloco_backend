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
The API uses the Devise gem for user authentication, and thus CRUD commands follow a different URI convention than the rest of the API. The API paths only allow GET requests through the API. All other CRUD requests for the user should be done through the following paths:

```
              user_login POST   /user/login(.:format)            user/sessions#create
             user_logout DELETE /user/logout(.:format)           user/sessions#destroy
             user_signup POST   /user/signup(.:format)           user/registrations#create

cancel_user_registration GET    /user/cancel(.:format)           user/registrations#cancel
   new_user_registration GET    /user/sign_up(.:format)          user/registrations#new
  edit_user_registration GET    /user/edit(.:format)             user/registrations#edit
                         PATCH  /user(.:format)                  user/registrations#update
                         PUT    /user(.:format)                  user/registrations#update
                         DELETE /user(.:format)                  user/registrations#destroy

           user_password POST   /user/password(.:format)         user/passwords#create
       new_user_password GET    /user/password/new(.:format)     user/passwords#new
      edit_user_password GET    /user/password/edit(.:format)    user/passwords#edit
                         PATCH  /user/password(.:format)         user/passwords#update
                         PUT    /user/password(.:format)         user/passwords#update

       user_confirmation POST   /user/confirmation(.:format)     user/confirmations#create
   new_user_confirmation GET    /user/confirmation/new(.:format) user/confirmations#new
                         GET    /user/confirmation(.:format)     user/confirmations#show
```

The full list of API routes can be accessed from the command line using ```rake api:routes```, but if the command line is not available, the complete list is as follows (not the "/v1" prefix):

```
# Users
 GET        /v1/users(.:format)
 GET        /v1/users/:id(.:format)

 GET        /v1/users/:id/transactions_created(.:format)
 GET        /v1/users/:id/transactions_created/:trans_id(.:format)
 GET        /v1/users/:id/transactions_accepted(.:format)
 GET        /v1/users/:id/transactions_accepted/:trans_id(.:format)

 GET        /v1/users/:id/vouchers_issued(.:format)
 GET        /v1/users/:id/vouchers_issued/:v_id(.:format)
 GET        /v1/users/:id/vouchers_claimed(.:format)
 GET        /v1/users/:id/vouchers_claimed/:v_id(.:format)

 GET        /v1/users/:id/redemptions(.:format)
 GET        /v1/users/:id/redemptions/:v_id(.:format)

# Transactions
 GET        /v1/transactions(.:format)
 GET        /v1/transactions/:id(.:format)
 POST       /v1/transactions(.:format)
 PUT        /v1/transactions/:id(.:format)
 DELETE     /v1/transactions/:id(.:format)

 # Vouchers
 GET        /v1/vouchers(.:format)
 GET        /v1/vouchers/:id(.:format)
 POST       /v1/vouchers(.:format)
 PUT        /v1/vouchers/:id(.:format)
 DELETE     /v1/vouchers/:id(.:format)

 # Redemptions
 GET        /v1/redemptions(.:format)
 GET        /v1/redemptions/:id(.:format)
 POST       /v1/redemptions(.:format)
 PUT        /v1/redemptions/:id(.:format)
 DELETE     /v1/redemptions/:id(.:format)
```


### API Notes

https://github.com/Apipie/apipie-rails

Apipie is included in the Gemfile but commented out. It is included for the eventual documentation of the API.

To see all API routes, run the following commend in terminal from your application directory: ```rake api:routes```
