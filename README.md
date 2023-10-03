This is source for a Ruby on Rails (Rails) web application that acts as a
trial platform for preference aggregation using the Davenport algorithm
for finding Kemeny orders.

The application was begun at the end of 2010,
abandoned, and picked-up again at the end of May, 2019.

## Development

- Check out the repository: `git checkout git@github.com:wbreeze/socelect.git`
- Change to the repository directory: `cd socelect`
- Install the Ruby programming environment at the level indicated in the
  file, `.ruby-version`. One way is to use
  [the Ruby environment manager (rbenv)][rbenv].
- Run the setup script: `script/setup`
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
