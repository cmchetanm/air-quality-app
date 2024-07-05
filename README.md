# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Requirements
  - Ruby 3.0.0
  - Libraries: bundler
## Dependencies
  - `bundle install`
## Configuration and setup
  - Set database username and password in 'credentials.yml.enc':
    `EDITOR='code --wait' bin/rails credentials:edit`
  - Create and setup the database:
    `bundle exec rails db:create`
    `bundle exec rails db:setup`
    `bundle exec rails db:seed`
## Run
  - Start server
    `bundle exec rails s`
  - And now you can visit the site with the URL http://localhost:3000
## Configure Open Wheather Service
  - Create account on Open Wheather Map Dashboard for API key and configure it to 'credentials.yml.enc'

    openwheathermap:
      api_key: 'API_KEY'