# encoding: utf-8

gem 'therubyracer', platforms: :ruby
gem 'nazca', git: "https://github.com/Azdaroth/nazca.git"
gem 'devise'
gem 'simple_form', '3.1.0rc2'
gem 'country_select'
gem 'cells'
gem 'draper'
gem 'carrierwave'
gem 'mini_magick'
gem 'pg'
gem 'haml'
gem "haml-rails"
gem 'bourbon'
gem 'capistrano', '~> 3.2.0'
gem "capistrano-rails"
gem 'capistrano-rvm'
gem 'capistrano-bundler'
gem 'will_paginate'
gem "polish"
gem 'sprockets-rails', :require => 'sprockets/railtie'
gem 'sprockets'
gem 'wiselinks'
gem 'crack'
gem "nested_form"
gem 'carrierwave_reupload_fix'
gem 'whenever'
gem 'virtus'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem "daemons"
gem "figaro", git: "https://github.com/laserlemon/figaro", ref: "7261234e1415f429bd2c972b568e89d639127b46"
gem 'airbrake'
gem 'schema_plus'
gem 'reform'
gem "less-rails"
gem 'twitter-bootstrap-rails', github: 'seyhunak/twitter-bootstrap-rails', branch: 'bootstrap3'
gem 'jquery-ui-rails'

gem_group :development, :test do
  gem 'quiet_assets'
  gem "better_errors"
  gem 'annotate'
  gem 'bullet'
  gem 'hirb'
  gem 'lol_dba'
  gem 'mailcatcher'
  gem 'meta_request'
  gem 'pry'
  gem 'pry-doc'
  gem 'rack-mini-profiler'
  gem 'railroady'
  gem 'rails-footnotes'
  gem 'request-log-analyzer'
  gem 'smusher'
  gem "cane", require: false
  gem "flog", require: false
  gem "flay", require: false
  gem "reek", require: false
  gem "roodi", require: false
  gem "churn", require: false
  gem "rails_best_practices", require: false
  gem "rubocop", require: false
  gem "brakeman", require: false
end

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-mocks'
  gem 'guard-rspec'
  gem 'awesome_print'
  gem 'jasmine-rails'
end

gem_group :test do
  gem 'poltergeist'
  gem 'capybara'
  gem 'rb-fsevent'
  gem 'growl'
  gem 'guard-spork'
  gem 'spork'
  gem 'spork-rails'
  gem 'factory_girl_rails', :require => false
  gem 'simplecov', :require => false
  gem 'database_cleaner'
end

gsub_file 'Gemfile', "gem 'turbolinks'", ''
run_bundle

create_file "app/controllers/static_pages_controller.rb",  <<-RUBY
class StaticPagesController < ApplicationController
  
  def home
    
  end

end
RUBY

run "mkdir app/views/static_pages"
create_file "app/views/static_pages/home.html.haml"

route "root to: 'static_pages#home'"

remove_file "public/index.html"

example_database_path = "config/database.yml.example"
database_path = "config/database.yml"
remove_file(database_path) 

app_name = ask("Specify app name:").underscore
db_username = ask("Specify db username:").underscore
db_password = ask("Specify db password:").underscore

create_file database_path,  <<-RUBY
development:
  adapter: postgresql
  encoding: unicode
  database: #{app_name}_development
  host: localhost
  pool: 5
  username: #{db_username}
  password: #{db_password}

test:
  adapter: postgresql
  encoding: unicode
  database: #{app_name}_test
  host: localhost
  pool: 5
  username: #{db_username}
  password: #{db_password}
RUBY

create_file example_database_path,  <<-RUBY
development:
  adapter: postgresql
  encoding: unicode
  database: #{app_name}_development
  host: localhost
  pool: 5
  username: your_username
  password: your_password

test:
  adapter: postgresql
  encoding: unicode
  database: #{app_name}_test
  host: localhost
  pool: 5
  username: your_username
  password: your_password

staging:
  adapter: postgresql
  encoding: unicode
  database: #{app_name}_staging
  host: localhost
  pool: 5
  username: your_username
  password: your_password

production:
  adapter: postgresql
  encoding: unicode
  database: #{app_name}_production
  host: localhost
  pool: 5
  username: your_username
  password: your_password

RUBY

rake "db:create:all"

run "rm -rf test"
generate "rspec:install"

rspec_file = ".rspec"
remove_file(rspec_file) 
create_file rspec_file ,  <<-RUBY
--color
RUBY

run "guard init rspec"
guard_file = "Guardfile"
remove_file(guard_file)
create_file guard_file, <<-RUBY
# A sample Guardfile
# More info at https://github.com/guard/guard#readme

ignore(/public\\/system/)

guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\\.rb$})
  watch(%r{^config/initializers/.+\\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb')
  watch('test/test_helper.rb')
  watch('spec/support/')
end

guard :rspec, cmd: 'bundle exec rspec', all_after_pass: false do
  watch(%r{^spec/.+_spec\\.rb$})
  watch(%r{^lib/(.+)\\.rb$})     { |m| "spec/lib/\#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^spec/.+_spec\\.rb$})
  watch(%r{^app/(.+)\\.rb$})                           { |m| "spec/\#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\\.erb|\.haml)$})                 { |m| "spec/\#{m[1]}\#{m[2]}_spec.rb" }
  watch(%r{^lib/(.+)\\.rb$})                           { |m| "spec/lib/\#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/\#{m[1]}_routing_spec.rb", "spec/\#{m[2]}s/\#{m[1]}_\#{m[2]}_spec.rb", "spec/acceptance/\#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('spec/spec_helper.rb')                        { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  # Capybara request specs
  watch(%r{^app/views/(.+)/.*\\.(erb|haml)$})          { |m| "spec/requests/\#{m[1]}_spec.rb" }

  watch(%r{^app/controllers/(.+)_(controller)\\.rb$})  do |m|
    ["spec/routing/\#{m[1]}_routing_spec.rb",
     "spec/\#{m[2]}s/\#{m[1]}_\#{m[2]}_spec.rb",
     "spec/acceptance/\#{m[1]}_spec.rb",
     (m[1][/_pages/] ? "spec/requests/\#{m[1]}_spec.rb" : 
                       "spec/requests/\#{m[1].singularize}_pages_spec.rb")]
  end
  watch(%r{^app/views/(.+)/}) do |m|
    (m[1][/_pages/] ? "spec/requests/\#{m[1]}_spec.rb" : 
                       "spec/requests/\#{m[1].singularize}_pages_spec.rb")
  end
end

RUBY

spec_helper = "spec/spec_helper.rb"
remove_file(spec_helper)
create_file spec_helper, <<-RUBY

require 'spork'
# This file was generated by the `rails generate rspec:install` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause this
# file to always be loaded, without a need to explicitly require it in any files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, make a
# separate helper file that requires this one and then use it only in the specs
# that actually need it.
#
# The `.rspec` file also contains a few flags that are not defaults but that
# users commonly want.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
# The settings below are suggested to provide a good initial experience
# with RSpec, but feel free to customize to your heart's content.

  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
    expectations.syntax = :expect
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
    mocks.syntax = :expect

    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended.
    mocks.verify_partial_doubles = true
  end

end

Spork.prefork do
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'draper/test/rspec_integration'


  # Requires supporting ruby files with custom matchers and macros, etc, in
  # spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
  # run as spec files by default. This means that files in spec/support that end
  # in _spec.rb will both be required and run as specs, causing the specs to be
  # run twice. It is recommended that you do not name files matching this glob to
  # end with _spec.rb. You can configure this pattern with with the --pattern
  # option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }


  # Checks for pending migrations before tests are run.
  # If you are not using ActiveRecord, you can remove this line.
  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  RSpec.configure do |config|

    Capybara.javascript_driver = :poltergeist
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, js_errors: false)
    end

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "\#{Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    config.include Capybara::DSL
    config.include(MailerMacros)
    config.before(:each) { reset_email }
  

  end

end

RUBY

rails_helper = "spec/rails_helper.rb"
remove_file(rails_helper)
create_file rails_helper, <<-RUBY

require 'spec_helper'

require 'rubygems'
module ActiveModel; module Observing; end; end # Prevents spork from exiting due to non-existent class in rails4.
require 'simplecov'
SimpleCov.start
require 'capybara/poltergeist'
require 'factory_girl_rails'


RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
end


RUBY


mailer_macros_file = "spec/support/mailer_macros.rb"
create_file mailer_macros_file, <<-RUBY
module MailerMacros
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def reset_email
    ActionMailer::Base.deliveries = []
  end

  def reset_with_delayed_job_deliveries
    ActionMailer::Base.deliveries = []
    Delayed::Job.destroy_all
  end

  def all_emails
    ActionMailer::Base.deliveries
  end

  def all_emails_sent_count
    ActionMailer::Base.deliveries.count
  end

  def all_emails_sent_count_with_dj
    ActionMailer::Base.deliveries.count + Delayed::Job.count
  end
end
RUBY

factories_file = "spec/factories.rb"
create_file factories_file , <<-RUBY
FactoryGirl.define do

end
RUBY

db_cleaner_file = "spec/support/database_cleaner.rb"
create_file db_cleaner_file, <<-RUBY
RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
RUBY

devise_tests_helper = "spec/support/devise.rb"
create_file devise_tests_helper, <<-RUBY
RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
end
RUBY


if yes?("Use Boostrap with Simple Form?")
  generate "simple_form:install --bootstrap"
else
  generate "simple_form:install"
end

generate "devise:install"

if yes?("Generate Devise model?")
  devise_model_name = ask("Specify devise model")
  generate "devise #{devise_model_name}"
end

if yes?("Generate Devise views?")
  generate "devise:views"
end


create_file "config/locales/devise.pl.yml", <<-RUBY
pl:
  errors:
    messages:
      expired: 'stracił ważność, wyślij zapytanie o nowy'
      not_found: 'nie znaleziono'
      already_confirmed: 'już został aktywowany, możesz się zalogować'
      confirmation_period_expired: "musi być potwierdzony w ciągu %{period}, wyślij ponownie zapytanie"
      not_locked: 'nie był zablokowany'
      not_saved:
        one: '%{resource} nie został zapisany z powodu błędu:'
        other: '%{resource} nie został zapisany z powodu następujących błędów:'
  devise:
    login: 'Zaloguj'
    remember_me: 'Zapamiętaj mnie'
    login_title: 'Logowanie'
    failure:
      last_attempt: "Pozostała jedna próba logowania. W przypadku braku sukcesu z logowaniem konto zostanie zablokowane."
      already_authenticated: 'Jesteś już zalogowany.'
      unauthenticated: 'Zaloguj lub zarejestruj się, aby kontynuować.'
      unconfirmed: 'Nie aktywowałeś/łaś jeszcze swojego konta - sprawdź swój e-mail.'
      locked: 'Twoje konto jest zablokowane.'
      invalid: 'Niepoprawny adres e-mail lub hasło.'
      invalid_token: 'Niepoprawny token.'
      timeout: 'Sesja wygasła - zaloguj się ponownie, aby kontynuować.'
      inactive: 'Konto nie zostało jeszcze aktywowane.'
      not_approved: 'Twoje konto nie zostało jeszcze uaktywnione przez administratora.'
      not_found_in_database: "Niewłaściwe hasło lub email."
    sessions:
      signed_in: 'Witaj ponownie!'
      signed_out: 'Wylogowano. Zapraszamy ponownie!'
    passwords:
      no_token: "Nie możesz wejść na tę stronę bez wykorzystania URLa wysłanego e-maila."
      send_instructions: 'Za chwilę wyślemy instrukcję zmiany hasła na Twój adres e-mail.'
      updated: 'Zmieniłeś/łaś swoje hasło. Zostałeś/łaś automatycznie zalogowany.'
      updated_not_active: 'Zmieniłeś/łaś swoje hasło.'
      send_paranoid_instructions: 'Jeśli wpisałeś/łaś poprawny e-mail, za chwilę wyślemy instrukcję zmiany hasła na Twój adres e-mail.'
    confirmations:
      send_instructions: 'Za chwilę wyślemy instrukcję aktywowania konta na Twój adres e-mail.'
      send_paranoid_instructions: 'Jeśli wpisałeś/łaś poprawny e-mail, za chwilę wyślemy instrukcję aktywowania konta na Twój adres e-mail.'
      confirmed: 'Aktywowałeś/łaś swoje konto. Jeśli nie zostałeś/łaś automatycznie zalogowany/a, poczekaj na aktywację konta przez administratora.'
    registrations:
      signed_up: 'Witaj! Zarejestrowałeś/łaś się pomyślnie.'
      signed_up_but_unconfirmed: 'E-mail z linkiem aktywacyjnym został wysłany na Twój adres e-mail. Sprawdź e-mail, aby dokończyć rejestrację.'
      signed_up_but_inactive: 'Zarejestrowałeś/łaś się pomyślnie. Niemniej jednak nie zostałeś/łaś zalogowany, ponieważ Twoje konto nie zostało jeszcze aktywowane.'
      signed_up_but_locked: 'Zarejestrowałeś/łaś się pomyślnie. Niemniej jednak nie zostałeś/łaś zalogowany, ponieważ Twoje konto zostało zablokowane.'
      updated: 'Zaktualizowałeś/łaś swoje dane.'
      update_needs_confirmation: 'Aby potwierdzić zmiany, musimy zweryfikować Twój nowy adres e-mail. Za chwilę wyślemy instrukcję na nowy adres.'
      destroyed: 'Usunąłeś/łaś swoje konto.'
      user:
        signed_up_but_not_approved: 'Rejestracja przebigła pomyślnie. E-mail z linkiem aktywacyjnym został wysłany na Twój adres e-mail, kliknij na podany w nim link. Prosimy następnie czekać na zatwierdzenie konta przez administratora'
#      inactive_signed_up: 'Zarejestrowałeś/łaś się pomyślnie. Nie zostałeś/łaś jednak zalogowany ponieważ konto jest %{reason}.'
#      reasons:
#        inactive: 'nieaktywne'
#        unconfirmed: 'niepotwierdzone'
#        locked: 'zablokowane'
    unlocks:
      send_instructions: 'Za chwilę wyślemy instrukcję odblokowania konta na Twój adres e-mail.'
      unlocked: 'Odblokowaliśmy Twoje konto. Jesteś już zalogowany.'
      send_paranoid_instructions: 'Jeśli Twoje konto istnieje w naszej bazie, otrzymasz zaraz e-mail z instrukcją jak odblokować swoje konto.'
    omniauth_callbacks:
      success: 'Zalogowałeś/łaś się przez %{kind}.'
      failure: 'Logowanie przez konto %{kind} zakończyło się błędem: "%{reason}".'
    mailer:
      confirmation_instructions:
        subject: 'Instrukcja aktywacji konta'
      reset_password_instructions:
        subject: 'Instrukcja ustawienia nowego hasła'
      unlock_instructions:
        subject: 'Instrukcja odblokowania konta'

RUBY

create_file "config/locales/pl.yml", <<-RUBY
pl:
  errors:
    messages:
       extension_white_list_error: "niewłaściwy format zdjęcia"
       wrong_url_format: "Niewłaściwy format adresu url - musi zawierać http://"

  simple_captcha:
    label: "Wpisz podany wyżej kod"
    placeholder: ""

  will_paginate:
    previous_label: "&#8592;  Cofnij"
    next_label: "Dalej &#8594;"
    page_gap: "&hellip;"
        
RUBY

if yes?("Using pow?")

  create_file ".powenv" , <<-RUBY
# detect `$rvm_path`
if [ -z "${rvm_path:-}" ] && [ -x "${HOME:-}/.rvm/bin/rvm" ]
then rvm_path="${HOME:-}/.rvm"
fi
if [ -z "${rvm_path:-}" ] && [ -x "/usr/local/rvm/bin/rvm" ]
then rvm_path="/usr/local/rvm"
fi
 
# load environment of current project ruby
if
  [ -n "${rvm_path:-}" ] &&
  [ -x "${rvm_path:-}/bin/rvm" ] &&
  rvm_project_environment=`"${rvm_path:-}/bin/rvm" . do rvm env --path 2>/dev/null` &&
  [ -n "${rvm_project_environment:-}" ] &&
  [ -s "${rvm_project_environment:-}" ]
then
  echo "RVM loading: ${rvm_project_environment:-}"
  \. "${rvm_project_environment:-}"
else
  echo "RVM project not found at: $PWD"
fi

RUBY

end

ruby_version = ask("Specify Ruby Verion")
create_file ".ruby-version", <<-RUBY
ruby-#{ruby_version}
RUBY

gitignore_file = ".gitignore"
remove_file(gitignore_file)
create_file gitignore_file, <<-RUBY

# See http://help.github.com/ignore-files/ for more about ignoring files.
#
# If you find yourself ignoring temporary files generated by your text editor
# or operating system, you probably want to add a global ignore instead:
#   git config --global core.excludesfile '~/.gitignore_global'

# Ignore bundler config
/.bundle

# Ignore the default SQLite database.
/db/*.sqlite3

# Ignore all logfiles and tempfiles.
/log/*.log
/tmp
/public/system/*
/public/uploads/*
/public/*.gz
# Ignore application configuration
.powenv
/coverage
/config/database.yml
/config/application.yml

RUBY

application "config.i18n.default_locale = :pl"
application "config.time_zone = 'Warsaw'"
application <<-RUBY

    config.autoload_paths += %W(\#{config.root}/app/usecases)
    config.autoload_paths += %W(\#{config.root}/app/forms)
    config.autoload_paths += %W(\#{config.root}/app/policies)

RUBY

create_file "config/initializers/errbit.rb", <<-RUBY
Airbrake.configure do |config|
  config.api_key = ENV["ERRBIT_API_KEY"]
  config.host    = ENV["ERRBIT_HOST"]
  config.port    = ENV["ERRBIT_PORT"]
  config.secure  = config.port == 443
end
RUBY


environment "config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'", env: 'production'
environment "config.action_mailer.default_url_options = { :host => 'hostname' }", env: 'production'

mailer_production_settings = <<-RUBY
ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.raise_delivery_errors = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => ENV["EMAIL_ADDRESS"],
    :port                 => 587,
    :domain               => ENV["EMAIL_DOMAIN"],
    :user_name            => ENV["EMAIL_USER_NAME"],
    :password             => ENV["EMAIL_PASSWORD"],
    :authentication       => 'plain',
    :enable_starttls_auto => true  }
RUBY

mailer_development_settings = <<-RUBY
config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
  :address              => ENV["EMAIL_ADDRESS"],
  :port                 => 587,
  :domain               => ENV["EMAIL_DOMAIN"],
  :user_name            => ENV["EMAIL_USER_NAME"],
  :password             => ENV["EMAIL_PASSWORD"],
  :authentication       => 'plain',
  :enable_starttls_auto => true  }
RUBY

environment mailer_production_settings, env: 'production'
environment mailer_development_settings, env: 'development'

development_bullet_settings = <<-RUBY
config.after_initialize do
    Bullet.enable = true
    Bullet.alert = false
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.growl = false
    Bullet.rails_logger = true
    Bullet.airbrake = false
    Bullet.add_footer = true
  end
RUBY

environment development_bullet_settings, env: 'development'

create_file "config/application.yml.example", <<-RUBY
development:
  EMAIL_ADDRESS: 
  EMAIL_DOMAIN:
  EMAIL_USER_NAME:
  EMAIL_PASSWORD: 
  ERRBIT_API_KEY: 
  ERRBIT_HOST: 
  ERRBIT_PORT: 
  SECRET_KEY_BASE:
RUBY

create_file "config/application.yml", <<-RUBY
development:
  EMAIL_ADDRESS: 
  EMAIL_DOMAIN:
  EMAIL_USER_NAME:
  EMAIL_PASSWORD: 
  ERRBIT_API_KEY: 
  ERRBIT_HOST: 
  ERRBIT_PORT: 
  SECRET_KEY_BASE:
RUBY

if yes?("Use whenever?")
  run "wheneverize ."
end

run "mkdir app/uploaders"
run "mkdir app/usecases"
run "mkdir app/cells"
run "mkdir app/decorators"
run "mkdir app/forms"
run "mkdir app/policies"

create_file "app/uploaders/application_images_uploader.rb", <<-RUBY
class ApplicationImagesUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file

  CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\\.\\-\\+]/

  def store_dir
    "system/\#{Rails.env}/\#{model.class.to_s.underscore}/\#{mounted_as}/\#{model.id}"
  end
  
  def extension_white_list
    %w(jpg jpeg gif png pdf tiff tif eps bmp ps)
  end

  private

    def rgbify
      unless Rails.env.test?
        begin
          manipulate! do |img|  
            img.colorspace "sRGB"
            img
          end
        end
      end
    end

    def efficient_conversion(width, height)
      manipulate! do |img|
        img.format("jpg") do |c|
          c.trim
          c.resize      "\#{width}x\#{height}>"
          c.resize      "\#{width}x\#{height}<"
        end
        img
      end
    end

end
RUBY

create_file "app/decorators/application_decorator.rb", <<-RUBY
class ApplicationDecorator < Draper::Decorator

  def self.collection_decorator_class
    PaginatingDecorator
  end

end

RUBY

create_file "app/decorators/paginating_decorator.rb", <<-RUBY
class PaginatingDecorator < Draper::CollectionDecorator
  delegate :current_page, :per_page, :offset, :total_entries, :next_page,
    :total_pages, :in_groups_of, :where, :includes
end
RUBY

create_file "app/cells/cells_utilities.rb", <<-RUBY
module CellsUtilities
  extend ActiveSupport::Concern

  included do
    helper_method :flash, :ancestor_controller, :namespace, :controller_name
  end

  def namespace
    @namespace ||= extract_namespace
  end

  def extract_namespace
    ancestor_controller.class.to_s.split('::').first.underscore
  end

  def ancestor_controller
    @ancestor_controller ||= extract_ancestor_controller
  end

  def controller_name
    ancestor_controller.class.to_s.split('::').last.underscore.chomp("_controller")
  end

  def extract_ancestor_controller
    parent = parent_controller
    while  parent.class.to_s.end_with?("Cell")
      parent = parent.parent_controller
    end
    parent
  end

  def flash
    ancestor_controller.flash
  end
end

RUBY

create_file "app/cells/application_cell.rb", <<-RUBY
class ApplicationCell < Cell::Rails
  
  include CellsUtilities
  
end
RUBY

generate "bootstrap:install static"
applicaiton_css_file = "app/assets/stylesheets/application.css"
remove_file applicaiton_css_file
create_file "#{applicaiton_css_file}.scss", <<-RUBY
/*
 * This is a manifest file that'll be compiled into application.css, which will include all the files
 * listed below.
 *
 * Any CSS and SCSS file within this directory, lib/assets/stylesheets, vendor/assets/stylesheets,
 * or vendor/assets/stylesheets of plugins, if any, can be referenced here using a relative path.
 *
 * You're free to add application-wide styles to this file and they'll appear at the top of the
 * compiled file, but it's generally better to create a new file per style scope.
 *
 *= require_self
 *= require jquery.ui.all
 *= require bootstrap_and_overrides
 */
RUBY


application_js_file = "app/assets/javascripts/application.js"
remove_file(application_js_file)
create_file application_js_file, <<-RUBY
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require wiselinks
//= require twitter/bootstrap

$(document).ready(function() {

  window.wiselinks = new Wiselinks($('#wiselinks'));

  $(document).off('page:done').on('page:done', function(event, $target, status, url, data) {    
  });

  $(document).off('page:loading').on('page:loading', function(event, $target, render, url) {
  });

  $(document).off('page:redirected').on('page:redirected', function(event, $target, render, url) {
  });

  $(document).off('page:always').on('page:always', function(event, xhr, settings) {
  });

});
RUBY


run "cp config/environments/production.rb config/environments/staging.rb"

create_file "Capfile", <<-RUBY
# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# Includes tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#
require 'capistrano/rvm'
# require 'capistrano/rbenv'
# require 'capistrano/chruby'
require 'capistrano/bundler'
# require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
# require 'whenever/capistrano'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
Dir.glob('lib/capistrano/**/*.rb').each { |r| import r }
RUBY

run "mkdir config/deploy"
run "mkdir config/deploy/shared"

app_name_deployment = ask("Specify application name on server:")
remote_repo = ask("Specify Repository Address:")
ruby_version_on_server = ask("Specify Ruby version on server:")
production_server_address = ask("Specify production server IP:")
staging_server_address = ask("Specify staging server IP:")
production_server_ssh_port = ask("Specify production server ssh port:")
staging_server_ssh_port = ask("Specify staging server ssh port:")


create_file "config/deploy.rb", <<-RUBY
# based on https://github.com/TalkingQuickly/capistrano-3-rails-template
set :application, "#{app_name_deployment}"
set :deploy_user, 'deploy'

set :pty, true
set :use_sudo, false

set :default_env, { rvm_bin_path: '/usr/local/rvm/bin/rvm' }
SSHKit.config.command_map[:rake] = "bundle exec rake"
set :default_shell, '/bin/bash --login'

# setup repo details
set :scm, :git
set :repo_url, "#{remote_repo}"

# setup rvm.
set :rvm_type, :system
set :rvm_ruby_version, "#{ruby_version_on_server}"

# how many old releases do we want to keep, not much
set :keep_releases, 5

# files we want symlinking to specific entries in shared
set :linked_files, %w{config/database.yml config/application.yml}

# dirs we want symlinking to shared
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, ["spec"]

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  nginx.conf
  database.example.yml
  application.example.yml
  log_rotation
))


# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc. The full_app_name variable isn't
# available at this point so we use a custom template {{}}
# tag and then add it at run time.
set(:symlinks, [
  # {
  #   source: "nginx.conf",
  #   link: "/etc/nginx/sites-enabled/{{full_app_name}}"
  # },
  # {
  #   source: "log_rotation",
  #   link: "/etc/logrotate.d/{{full_app_name}}"
  # }
])


namespace :deploy do
  before :deploy, "deploy:check_revision"
  before :deploy, "deploy:run_tests"
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'
  after 'deploy:publishing', 'deploy:restart'
end

# after 'deploy:publishing', 'deploy:restart'                                     
# namespace :deploy do                                                            
#   task :restart do                                                                                                               
#     invoke 'delayed_job:restart'                                                
#   end                                                                           
# end


RUBY


create_file "config/deploy/production.rb", <<-RUBY
set :ssh_options, {
  forward_agent: true,
  port: "#{production_server_ssh_port}"
}

set :stage, :production
set :branch, "master"

# used in case we're deploying multiple versions of the same
# app side by side. Also provides quick sanity checks when looking
# at filepaths
set :full_app_name, "\#{fetch(:application)}_\#{fetch(:stage)}"

server "#{production_server_address}", user: 'deploy', roles: %w{web app db}, primary: true

set :deploy_to, "/home/\#{fetch(:deploy_user)}/apps/\#{fetch(:full_app_name)}"

# dont try and infer something as important as environment from
# stage name.
set :rails_env, :production

# whether we're using ssl or not, used for building nginx
# config file
set :enable_ssl, false
RUBY


create_file "config/deploy/staging.rb", <<-RUBY
set :ssh_options, {
  forward_agent: true,
  port: "#{staging_server_ssh_port}"
}

set :stage, :staging
set :branch, "staging"

# used in case we're deploying multiple versions of the same
# app side by side. Also provides quick sanity checks when looking
# at filepaths
set :full_app_name, "\#{fetch(:application)}_\#{fetch(:stage)}"

server "#{staging_server_address}", user: 'deploy', roles: %w{web app db}, primary: true

set :deploy_to, "/home/\#{fetch(:deploy_user)}/apps/\#{fetch(:full_app_name)}"

# dont try and infer something as important as environment from
# stage name.
set :rails_env, :staging

# whether we're using ssl or not, used for building nginx
# config file
set :enable_ssl, false
RUBY

capistrano_shared_dir = "config/deploy/shared"

create_file "#{capistrano_shared_dir}/nginx.conf.erb", <<-RUBY
server {

  listen       80;
  root <%= fetch(:deploy_to) %>/current/public;
  passenger_enabled on;
  rails_env <%= fetch(:stage) %>;  

  location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }

  client_max_body_size 4G;
}

<% if fetch(:enable_ssl) %>
server {
  listen 443 default deferred;
  root <%= fetch(:deploy_to) %>/current/public;

  location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }

  client_max_body_size 4G;
  ssl on;
  ssl_certificate <%= fetch(:deploy_to) %>/shared/ssl_cert.crt;
  ssl_certificate_key <%= fetch(:deploy_to) %>/shared/ssl_private_key.key;
}
<% end %>
RUBY

create_file "#{capistrano_shared_dir}/database.example.yml.erb", <<-RUBY
<%= fetch(:rails_env) %>:
  adapter: postgresql
  encoding: unicode
  database: <%= "\#{fetch(:application)}_\#{fetch(:rails_env)}" %>
  username: <%= "\#{fetch(:application)}" %>
  password:
  pool: 5
  host: localhost
RUBY

create_file "#{capistrano_shared_dir}/application.example.yml.erb", <<-RUBY
<%= fetch(:rails_env) %>:
  EMAIL_ADDRESS: 
  EMAIL_DOMAIN:
  EMAIL_USER_NAME:
  EMAIL_PASSWORD: 
  ERRBIT_API_KEY: 
  ERRBIT_HOST: 
  ERRBIT_PORT: 
  SECRET_KEY_BASE:
RUBY

create_file "#{capistrano_shared_dir}/log_rotation.erb", <<-RUBY
<%= fetch(:deploy_to) %>/shared/log/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    sharedscripts
    endscript
    copytruncate
}
RUBY


run "mkdir lib/capistrano"
capistrano_tasks_dir = "lib/capistrano/tasks"
run "mkdir #{capistrano_tasks_dir}"

create_file "lib/capistrano/substitute_strings.rb", <<-RUBY
# based on https://github.com/TalkingQuickly/capistrano-3-rails-template
# we often want to refer to variables which
# are defined in subsequent stage files. This
# let's us use the {{var}} to represent fetch(:var)
# in strings which are only evaluated at runtime.

def sub_strings(input_string)
  output_string = input_string
  input_string.scan(/{{(\\w*)}}/).each do |var|
    output_string.gsub!("{{\#{var[0]}}}", fetch(var[0].to_sym))
  end
  output_string
end
RUBY

create_file "lib/capistrano/template.rb", <<-RUBY
# based on https://github.com/TalkingQuickly/capistrano-3-rails-template
# will first try and copy the file:
# config/deploy/\#{full_app_name}/\#{from}.erb
# to:
# shared/config/to
# if the original source path doesn exist then it will
# search in:
# config/deploy/shared/\#{from}.erb
# this allows files which are common to all enviros to
# come from a single source while allowing specific
# ones to be over-ridden
# if the target file name is the same as the source then
# the second parameter can be left out
def smart_template(from, to=nil)
  to ||= from
  full_to_path = "\#{shared_path}/config/\#{to}"
  if from_erb_path = template_file(from)
    from_erb = StringIO.new(ERB.new(File.read(from_erb_path)).result(binding))
    upload! from_erb, full_to_path
    info "copying: \#{from_erb} to: \#{full_to_path}"
  else
    error "error \#{from} not found"
  end
end

def template_file(name)
  if File.exist?((file = "config/deploy/\#{fetch(:full_app_name)}/\#{name}.erb"))
    return file
  elsif File.exist?((file = "config/deploy/shared/\#{name}.erb"))
    return file
  end
  return nil
end

RUBY

create_file "#{capistrano_tasks_dir}/check_revision.cap", <<-RUBY
# based on https://github.com/TalkingQuickly/capistrano-3-rails-template
namespace :deploy do
  desc "checks whether the currently checkout out revision matches the
        remote one we're trying to deploy from"
  task :check_revision do
    branch = fetch(:branch)
    unless `git rev-parse HEAD` == `git rev-parse origin/\#{branch}`
      puts "WARNING: HEAD is not the same as origin/\#{branch}"
      puts "Run `git push` to sync changes or make sure you've"
      puts "checked out the branch: \#{branch} as you can only deploy"
      puts "if you've got the target branch checked out"
      exit
    end
  end
end
RUBY

create_file "#{capistrano_tasks_dir}/compile_assets_locally.cap", <<-RUBY
# based on https://github.com/TalkingQuickly/capistrano-3-rails-template
namespace :deploy do
  desc "compiles assets locally then rsyncs"
  task :compile_assets_locally do
    run_locally do
      execute "RAILS_ENV=\#{fetch(:rails_env)} bundle exec rake assets:precompile"
    end
    on roles(:app) do |role|
      run_locally do
        execute "rsync -av -e \\\"ssh -p \#{fetch(:ssh_options)[:port]}\\\" ./public/assets/ \#{role.user}@\#{role.hostname}:\#{release_path}/public/assets/;"
      end
    end
    run_locally do
      execute "rm -rf ./public/assets"
    end
  end
end

RUBY

create_file "#{capistrano_tasks_dir}/logs.cap", <<-RUBY
# based on https://github.com/TalkingQuickly/capistrano-3-rails-template
namespace :logs do
  task :tail, :file do |t, args|
    if args[:file]
      on roles(:app) do
        execute "tail -f \#{shared_path}/log/\#{args[:file]}.log"
      end
    else
      puts "please specify a logfile e.g: 'rake logs:tail[logfile]"
      puts "will tail 'shared_path/log/logfile.log'"
      puts "remember if you use zsh you'll need to format it as:"
      puts "rake 'logs:tail[logfile]' (single quotes)"
    end
  end
end
RUBY

create_file "#{capistrano_tasks_dir}/restart.cap", <<-RUBY
namespace :deploy do
  desc 'Restart passenger'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "touch \#{current_path}/tmp/restart.txt"
    end
  end
end

RUBY

create_file "#{capistrano_tasks_dir}/run_tests.cap", <<-RUBY
# based on https://github.com/TalkingQuickly/capistrano-3-rails-template
namespace :deploy do
  desc "Runs test before deploying, can't deploy unless they pass"
  task :run_tests do
    test_log = "log/capistrano.test.log"
    tests = fetch(:tests)
    tests.each do |test|
      puts "--> Running tests: '\#{test}', please wait ..."
      unless system "bundle exec rspec \#{test} > \#{test_log} 2>&1"
        puts "--> Tests: '\#{test}' failed. Results in: \#{test_log} and below:"
        system "cat \#{test_log}"
        exit;
      end
      puts "--> '\#{test}' passed"
    end
    puts "--> All tests passed"
    system "rm \#{test_log}"
  end
end

RUBY

create_file "#{capistrano_tasks_dir}/setup_config.cap", <<-RUBY
# based on https://github.com/TalkingQuickly/capistrano-3-rails-template
namespace :deploy do
  task :setup_config do
    on roles(:app) do
      # make the config dir
      execute :mkdir, "-p \#{shared_path}/config"
      full_app_name = fetch(:full_app_name)

      # config files to be uploaded to shared/config, see the
      # definition of smart_template for details of operation.
      # Essentially looks for \#{filename}.erb in deploy/\#{full_app_name}/
      # and if it isn't there, falls back to deploy/\#{shared}. Generally
      # everything should be in deploy/shared with params which differ
      # set in the stage files
      config_files = fetch(:config_files)
      config_files.each do |file|
        smart_template file
      end

      # which of the above files should be marked as executable
      executable_files = fetch(:executable_config_files)
      if executable_files
        executable_files.each do |file|
          execute :chmod, "+x \#{shared_path}/config/\#{file}"
        end
      end

      # symlink stuff which should be... symlinked
      symlinks = fetch(:symlinks)

      symlinks.each do |symlink|
        sudo "ln -nfs \#{shared_path}/config/\#{symlink[:source]} \#{sub_strings(symlink[:link])}"
      end
    end
  end
end

RUBY

create_file "#{capistrano_tasks_dir}/delayed_job.cap", <<-RUBY
namespace :delayed_job do

  def args
    fetch(:delayed_job_args, "")
  end

  def delayed_job_roles
    fetch(:delayed_job_server_role, :app)
  end

  desc 'Stop the delayed_job process'
  task :stop do
    on roles(delayed_job_roles) do
      within release_path do    
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :'script/delayed_job', :stop
        end
      end
    end
  end

  desc 'Start the delayed_job process'
  task :start do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :'script/delayed_job', args, :start
        end
      end
    end
  end

  desc 'Restart the delayed_job process'
  task :restart do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :'script/delayed_job', args, :restart
        end
      end
    end
  end
end
RUBY

git :init
git add: "."
git commit: "-a -m 'Setup basic app skeleton by WebSynergia Rails App Starter Kit (RASK)'"
git remote: "add origin #{remote_repo}"

run "echo 'Thank you for using WebSynergia Rails App Starter Kit (RASK)'"