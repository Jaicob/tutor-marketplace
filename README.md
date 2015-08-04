Web App  [![Build Status](https://api.shippable.com/projects/556f5e52edd7f2c05207296b/badge?branchName=master)](https://app.shippable.com/projects/556f5e52edd7f2c05207296b/builds/latest)
================

This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.io/).


Ruby on Rails
-------------

This application requires:

- Ruby 2.2.0
- Rails 4.2.1

Learn more about [Installing Rails](http://railsapps.github.io/installing-rails.html).

Getting Started
---------------
- Clone the repo
- Install Boot2Docker if on Windows or OS X
- Install Docker-Compose and Docker
- Request a copy of the application.yml and place in config/application.yml
- Run `docker-compose up`
- Get your boot2docker ip using `boot2docker ip 2`
- Inside the container run `rake db:create db:migrate`
- Inside the container run `rake bower:install` 
- You can visit the running application at that ip on port 3000
- I would recommend adding dockerhost as known host on your machine for ease of access
- open a shell using `docker exec -it webapp_web_1 /bin/bash`
- Restart the server by using `docker-compose stop` then   `docker-compose up` or  `docker-compose start`
-  `docker-compose start` will run it as a daemon where as  `docker-compose up` is in the foreground
-  All file changes should be made locally and any rake or bundle commands should be run inside the container

Redis Server for Background Jobs
--------------------------------
- Sidekiq and Redis handle our background processes, currently just sending emails
- Even Devise sends email in the background (as well as all appointment emails) and Redis must be running for Devise emails to work
- To start the Redis server (from the root)
  -- 'cd redis-stable'
  -- 'make install'
  -- 'redis-server'
- If that doesn't work, make sure you have Redis installed. You can follow the instructions at http://redis.io/topics/quickstart
- Also, to monitor background processes, visit dockerhost:3000/sidekiq

Documentation and Support
-------------------------

Issues
-------------
- If there are issues with the docker containers let jaicob@axontutors.com know and he will be in touch to make your troubles disappear (hopefully)

Similar Projects
----------------
There can only be one.
