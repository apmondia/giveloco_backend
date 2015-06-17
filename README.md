Taliflo API
===============

Taliflo API built with Ruby on Rails using Grape.

## Requirements

- [PostgreSQL](http://www.postgresql.org/)
- [bundler](http://bundler.io/)

If you're using Mac OS X you can install these with  [homebrew](http://brew.sh/)

### Suggested

- [rbenv](https://github.com/sstephenson/rbenv)

## Setup

After you clone the repository run:

```
bundle install
```

```
bundle exec rake db:create db:migrate db:seed
```

To seed some fake data:

```
rake db:seed:development
```

To run the server:

```
rails s
```

## Environments

Rails has three built-in environments: test, development and production.

The test environment is intended for running tests; it assumes any data in the database is ephemeral and starts the server on a random port.

The development environment is what you run on your local machine.  It starts the server listening on port 3000.

The production environment is tuned to where you are deploying the application, and will be optimized as such.

All ```rake``` commands by default run within the development environment.  To explicitly set the environment use the environment variable RAILS_ENV:

```
RAILS_ENV=test bundle exec rake db:create db:migrate db:seed
```

## Installing seed data

To add dummy data to the database so that you can play with the API run:

```
bundle exec rake db:seed:development
```

If you'd like to install some particular data try looking at the rake tasks:

```
rake -T
```

## Running the tests

The back-end includes a battery of test that ensure the system is in working order.  There are tests that are back-end only, and there are feature tests that are designed to test the front-end and the back-end together, in tandem.

To run all the tests, including the feature tests, you must first have a front-end server running locally in the test environment.  I.e.

```
gulp build-test
```

Once the front-end is running, you can run all of the back-end tests using:

```
bundle exec rake spec
```
