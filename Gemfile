source 'https://rubygems.org'

# for compatibility with ruby 2.6
gem 'nokogiri', '~>1.16.2'

gem 'rails', '~>5.2.8'
gem 'bootsnap'
gem 'davenport'
gem 'active_type'
gem 'delayed_job_active_record'
gem 'daemons'

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
  gem 'sqlite3'
end

group :production do
  gem 'mysql2'
end
