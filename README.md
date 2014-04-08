Rails App Starter Kit
=====================

![websynergia](http://websynergia.com.pl/images/logo_websynergia.jpg)

Rails application template we use in WebSynergia. Convention over configuration to the maximum.

Huh? Another Rails app template?
-------

There are other solutions which offer pretty good generators for new applications like http://railsapps.github.io/rails-composer/ . However, we have strong opinions about organizing stuff in our apps and currently available templates are not enough. We want to automate everything and rapidly start developing new app, not copy configuration files between projects.

Features
-------

* Extensive Gemfile with code and performance analysis tools
* PostgreSQL database setup
* Twitter Bootstrap 2.3
* Simple Form
* Devise
* RSpec / Capybara / Poltergeist / Jasmine / Guard / Spork / FactoryGirl / Database Cleaner setup
* Wiselinks (instead of Turbolinks) by default
* App's structure organization (app/usecases, app/forms, app/decorators, app/cells etc. by default)
* Abstract classes enhancing functionality (ApplicationDecorator, ApplicationImagesUploader, ApplicationCell)
* Enhanced environment files
* Staging environment
* Capistrano 3.1 deployment recipes for both staging and production environments with template files for Nginx (with Passenger), logrotation, database.yml and application.yml and custom tasks for even faster setup (based on https://github.com/TalkingQuickly/capistrano-3-rails-template by Ben Dixon)

TO-DO
-------

* Current template is pretty messy (everything in one file), it needs better organization
* Extract some functionality to separate gem(s) (classes like ApplicationImagesUploader, common helpers)
* Locales for different languges 
* Customizable application.rb file (timezone and default locale config - currently it's Warsaw and :pl by default)
* Add option to choose Sidekiq over Delayed Job
* Setup for Angular JS

That's awesome. How do I use it?
-------

Just create new app the usual way with additional argument:

```
rails new app_name -m https://raw.githubusercontent.com/WebSynergia/rails_app_starter_kit/master/template.rb
```

Now you can instantly start developing new app without any additional setup. Enjoy!

![websynergia](http://websynergia.com.pl/images/logo_websynergia.jpg)
