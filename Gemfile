source 'http://rubygems.org'

gem 'rails', '~>3.2.0'

# auth
gem 'omniauth-facebook'
# gem 'devise'
# gem 'cancan'

# fook
gem 'fb_graph'

gem 'resque', :require => 'resque/server'
gem 'resque-scheduler', :require => 'resque_scheduler'

gem 'yajl-ruby'
gem 'rabl'

gem 'factory_girl_rails'

gem "paperclip", "~> 2.7"
gem 'aws-s3'
gem 'aws-sdk'
gem 'rmagick'

gem 'foreman'

gem 'private_pub'

gem 'coffee-filter'

gem 'pry-rails'

gem 'jquery-rails'
gem 'haml-rails'
gem 'html5-rails', :git => 'git://github.com/sporkd/html5-rails.git'
gem 'rails-backbone'
gem 'requirejs-rails'

group :development, :test do
  gem 'webrick'
  gem 'sqlite3'
end

# heroku postgre
group :production do
  gem 'thin'
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass', '0.12.alpha.2'
  gem 'compass-h5bp'
end

group :development, :test do
  gem 'therubyracer', :platforms => :ruby
  gem 'execjs'

  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false

  gem 'rspec-rails'
  gem 'cucumber-rails'
  # gem 'cucumber_factory'
  gem 'webrat'
  gem 'database_cleaner'
  gem 'selenium-client'
  gem 'selenium-webdriver'
	gem 'launchy'
	gem 'guard-rspec'
	gem 'guard-cucumber'
  gem 'spork'
  gem 'guard-spork'
  # gem 'guard-rails-assets'
end
