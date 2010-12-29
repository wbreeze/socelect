source 'http://rubygems.org'

gem 'rails', '3.0.3'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
   gem 'sqlite3-ruby', "= 1.2.5", :require => 'sqlite3'
end

group :production do
   gem 'mysql2'
end
