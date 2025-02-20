This is source for a Ruby on Rails (Rails) web application that acts as a
trial platform for preference aggregation using the Davenport algorithm
for finding Kemeny orders.

The application was begun at the end of 2010,
abandoned, and picked-up again at the end of May, 2019.

## Development

- You will need mySQL.
  - On MacOS with Homebrew, `brew install mysql`
  - run it with `/opt/homebrew/opt/mysql/bin/mysqld_safe --datadir\=/opt/homebrew/var/mysql`
- You will need to have the Davenport library installed.
  - See https://github.com/wbreeze/davenport
- Check out the repository: `git checkout git@github.com:wbreeze/socelect.git`
- Change to the repository directory: `cd socelect`
- Install the Ruby programming environment at the level indicated in the
  file, `.ruby-version`. One way is to use
  [the Ruby environment manager (rbenv)][rbenv].
- Run `bundle install`
- Start the Rails server for development: `rails server --environment=development`
- Visit the [locally hosted development site][rdev] to try the app locally

[rbenv]: https://github.com/rbenv/rbenv#installation
[rdev]: https://localhost:3000

### Delayed-job

For testing the queueing and delayed processing in development, use the
command `delayed_job --pool=result_state:1 --pool=result_compute:2 start`.
The Capistrano deploy for production is set-up to run the same.

The result_state queue should have only one worker, because it is used to
serialize the state changes. There can be as many workers as you like on
the result_compute queue.
