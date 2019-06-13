source 'https://rubygems.org'

gem 'rails', '~>5.2.0'
gem 'bootsnap'
gem 'slug'

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
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'timecop'
end

group :development, :test, :production do
  gem 'sqlite3'
end
