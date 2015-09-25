#!/bin/bash
bundle
bundle exec rails s -b 0.0.0.0 -p 3000
bundle exec sidekiq