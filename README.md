[![Build Status](https://travis-ci.org/wbreeze/socelect.svg?branch=master)](https://travis-ci.org/wbreeze/socelect)

This is source for a Ruby on Rails (Rails) web application that acts as a
trial platform for preference aggregation using the Davenport algorithm
for finding Kemeny orders.

The application was begun at the end of 2010,
abandoned, and picked-up again at the end of May, 2019.

For testing the queueing and delayed processing in development, use the
command `delayed_job --pool=result_state:1 --pool=result_compute:2 start`.
The Capistrano deploy for production is set-up to run the same.

The result_state queue should have only one worker, because it is used to
serialize the state changes. There can be as many workers as you like on
the result_compute queue.
