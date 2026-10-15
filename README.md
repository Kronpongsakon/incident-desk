# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Users

There is no sign-up. Every user has exactly one role: `customer` or `agent`.

* Seed one customer (`customer@example.com`) and one agent (`agent@example.com`). Both get the password in `SEED_PASSWORD`; without it, the seeds skip them:

  ```sh
  SEED_PASSWORD=... bin/rails db:seed
  ```

* Create any other user. The task reads the password from `PASSWORD` or asks for it, so it never lands in shell history as an argument:

  ```sh
  bin/rails "users:create[jane@example.com,agent]"
  ```
