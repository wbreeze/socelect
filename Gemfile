source 'https://rubygems.org'

gem 'rails', '~>7.0.0'
gem 'davenport'
gem 'active_type'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'webpacker'

gem 'bootsnap'
gem 'bigdecimal'
gem 'mutex_m'
gem 'drb'

group :assets do
  gem 'uglifier'
end

group :development do
  gem 'listen'

  # for deployment
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano3-delayed-job'
end

group :test do
  gem 'capybara'
  gem 'faker'
  gem 'launchy'
  gem 'selenium-webdriver'
end

group :development, :test do
  gem 'sqlite3', '~> 1.4'
end

group :production do
  gem 'mysql2'
end
