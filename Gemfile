source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0.0'

# Use same server for both development and production so that we can
# use foreman to automatically set variables in .env
gem 'puma', '~> 2.0.1'

group :production do
  gem 'pg', '~> 0.15.1' #for heroku, PostgreSQL
  #gem 'newrelic_rpm', '~> 3.6.2.96'
  
  # Scaling workers automatically on Heroku
  #gem 'workless', '~> 1.1.2'
  
  #For static asset serving and logging on heroku
  gem 'rails_12factor', '~> 0.0.2'
end

group :development do
  gem 'sqlite3', '~> 1.3.8'
  gem 'rspec-rails', '~> 2.13.2'
  gem 'annotate', '~> 2.5.0'
  # Place `debugger` somewhere in code to set breakpoint
  #gem 'debugger', '~> 1.6.0'
  gem 'haml-rails', '~> 0.4.0' #for haml generators
end

group :test do
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
#gem 'jbuilder', '~> 1.2'
# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

gem 'devise', '~> 3.1.1'
gem 'rails_admin', '~> 0.5.0'

gem 'haml', '~> 4.0.3'
#gem 'compass-rails', '~> 2.0.alpha.0'
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'font-awesome-sass-rails', '~> 3.0.2.2' #for better glyphs

gem 'high_voltage', '~> 2.0.0' #for static pages

gem 'route53', '~> 0.2.1' #for Amazon Route53 DNS

#Need to use git version of grape since 0.6.0 has a serious bug in requires 
#type checking: https://github.com/intridea/grape/issues/490
#gem 'grape', '~> 0.6.0' #for API
gem 'grape', :git => 'git://github.com/intridea/grape.git'
