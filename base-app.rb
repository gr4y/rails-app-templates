#===========================================
# gems

gem 'haml-rails'
gem 'bourbon'
gem 'simple_form'
gem 'puma'

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
end

gem_group :test do
  gem 'faker'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
end

run "bundle install"
run "bundle exec rails g rspec:install"
run "bundle exec guard init rspec"
run "bundle exec rails g simple_form:install"

#===========================================
# disable some generators, add rspec, haml and factory_girl

application_rb = File.open('config/application.rb').readlines
config = <<-RUBY

  config.generators do |g|
    g.stylesheets = false
    g.javascripts = false
    g.helper = false
    
    g.template_engine :haml
    
    g.test_framework :rspec,
      fixtures: true,
      view_specs: false,
      helper_specs: false,
      routing_specs: false,
      controller_specs: true,
      request_specs: false
    g.fixture_replacement :factory_girl, dir: 'spec/factories'
  end

RUBY
new_application_rb = ((application_rb.clone[0..-3] << config) + application_rb[-2..-1]).join
file 'config/application.rb', new_application_rb, :force => true

#===========================================
# git initialization

git :init
git add: "."
git commit: %Q{ -m 'Initial Import' }
