#!/bin/bash
cd /home/rails/my-app/ 
bundle exec sidekiq -e production -L sidekiq.log