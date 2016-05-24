FROM jaicob/rails-nginx-unicorn
MAINTAINER jaicob(jaicob@icloud.com)

# Install tools needed
RUN sudo npm install -g bower && \
	sudo apt-get update && \
	yes | sudo apt-get install xvfb && \
	yes | sudo apt-get install dbus --fix-missing && \
	gem install bundler

# Place correct Application.yml
COPY config/application.yml /home/rails/my-app/config/application.yml

# Place custom unicorn configs/scripts here
COPY config/unicorn.rb /etc/my-app/config/unicorn.rb
COPY scripts/unicorn_init.sh /etc/init.d/unicorn

# Place custom nginx configs here
COPY config/nginx-production-site.conf /etc/nginx/sites-available/production.conf
COPY config/nginx-staging-site.conf /etc/nginx/sites-available/staging.conf
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure supervisor
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy in the script used at startup
COPY scripts/startup.sh /etc/my-app/startup.sh

# Expose port 80
EXPOSE 80
RUN bundle install

CMD ["sh", "-c", "/etc/my-app/startup.sh"]
