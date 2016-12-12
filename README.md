
Mailgun_app

Things you may want to cover:

* Ruby version: 2.3.1

* System dependencies : linux

* Configuration
  System should have redis setup

* Database creation
  run command `rails db:create`

* Database initialization
  run `rails db:migrate`
  run `rake db:seed`

* How to run the test suite
  run `rails test`

* Services (job queues, cache servers, search engines, etc.)
  run `bundle exec sidekiq -q high,5 default`
