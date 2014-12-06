The demo application is deployed at http://calories-app.herokuapp.com

# Stack

* Ruby on Rails for REST API
* AngularJS client
* PostgreSQL
* Tests with rspec, capybara and selenium

# Development setup

    rake db:create
    rake db:migrate
    rails server

# Tests

## API request specs

    rake spec:requests

## Integration tests

    rake spec:features

# Deployment to Heroku

## Setup

    heroku create
    heroku run rake db:migrate

## Deployment

    git push heroku master
