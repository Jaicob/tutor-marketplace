Web App  [![Build Status](https://api.shippable.com/projects/556f5e52edd7f2c05207296b/badge?branchName=development)](https://app.shippable.com/projects/556f5e52edd7f2c05207296b/builds/latest)
================

This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.io/).

Rails Composer is open source and supported by subscribers. Please join RailsApps to support development of Rails Composer.

Problems? Issues?
-----------

Need help? Ask on Stack Overflow with the tag 'railsapps.'

Your application contains diagnostics in the README file. Please provide a copy of the README file when reporting any issues.

If the application doesn't work as expected, please [report an issue](https://github.com/RailsApps/rails_apps_composer/issues)
and include the diagnostics.

Ruby on Rails
-------------

This application requires:

- Ruby 2.2.0
- Rails 4.2.1

Learn more about [Installing Rails](http://railsapps.github.io/installing-rails.html).

Getting Started
---------------

Documentation and Support
-------------------------

New Docker Start Up
  source ~/.profile
  docker-compose start

  docker-compose run web tail -f log/development.log
  -to see server logs

  docker-compose run web /bin/bash
  -to open a shell in docker container

Switching from Selenium-Webdriver to Capybara-Webkit for JS testing
  -capybara-webkit uses the QtWebKit port, which depends on the Qt windowing framework. Even though the whole point is to run WebKit without windows, the compilation process has dependencies on Qt.
  -Ubuntu users can 'sudo apt-get install libqt4-dev' to get Qt


Issues
-------------

Similar Projects
----------------

Contributing
------------

Credits
-------

License
-------
