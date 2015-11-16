FROM jaicob/rails-nginx-unicorn
MAINTAINER jaicob(jaicob@icloud.com)

WORKDIR /home/rails/my-app

# Install bower
RUN sudo npm install -g bower

# Install virtual window for capybara-webkit
RUN sudo apt-get update
RUN yes | sudo apt-get install xvfb
RUN yes | sudo apt-get install dbus --fix-missing

# Place custom unicorn configs here
COPY config/unicorn.rb /etc/my-app/config/unicorn.rb

# Configure supervisor
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#sidekiq startup script
# COPY sidekiq.sh /usr/local/bin/sidekiq

COPY unicorn_init.sh /etc/init.d/unicorn

# Place custom nginx configs here
COPY config/nginx-app-site.conf /etc/nginx/sites-enabled/default
COPY config/nginx.conf /etc/nginx/nginx.conf

#SSl Certs
COPY config/certs/ssl/ssl-bundle.crt /etc/ssl/ssl-bundle.crt
COPY config/certs/ssl/privatekey.pem /etc/ssl/privatekey.pem

# Add custom setup script here TODO change name to setup.sh
COPY setup.sh /etc/my-app/setup.sh

# Run setup script. This sets up the tmp folder and symlinks it to shared
# as well as sets up the database if necessary
RUN /etc/my-app/setup.sh
RUN gem install bundler

# Expose port 80
EXPOSE 80
EXPOSE 443

# Set environment
ENV RAILS_ENV production

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
