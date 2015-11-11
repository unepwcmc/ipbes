source 'https://rubygems.org'

gem 'rails', '3.2.22'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg', '>= 0.15.0'
gem 'bootstrap-generators', :git => 'git://github.com/decioferreira/bootstrap-generators.git'
gem 'simple_form'
gem 'devise', '>=3.5.2'
gem 'sitemap_generator'
gem 'cancan'
gem 'nokogiri', '>= 1.5'
gem 'paperclip', '>=4.3.1'
gem 'whenever', :require => false
gem 'geocoder'
gem 'kaminari'
gem 'redcarpet', '>=3.3.3'
gem 'rails_autolink'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

group :development do
  # Deploy with Capistrano
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'brightbox', '>=2.3.9'
  gem 'byebug'
end

group :staging, :production do
  gem 'exception_notification'
  gem 'slack-notifier', '~> 1.0'
end

gem 'jquery-rails', '>=3.1.3'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
