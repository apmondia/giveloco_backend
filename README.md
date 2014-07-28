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


### API Notes

https://github.com/Apipie/apipie-rails

Apipie is included in the Gemfile but commented out. It is included for the eventual documentation of the API.

To see all API routes, run the following commend in terminal from your application directory: ```rake api:routes```
