FROM jaicob/rails-nginx-unicorn
MAINTAINER jaicob(jaicob@icloud.com)

# Environment set in deploy script 
ENV RAILS_ENV staging

# Install tools needed
RUN sudo npm install -g bower && \
	sudo apt-get update && \
	yes | sudo apt-get install xvfb && \
	yes | sudo apt-get install dbus --fix-missing && \
	gem install bundler

# Place correct Application.yml
COPY config/application.yml /home/rails/my-app/config/application.yml

RUN RAILS_ENV=staging bundle install

# Place custom unicorn configs/scripts here
COPY config/unicorn.rb /etc/my-app/config/unicorn.rb
COPY scripts/unicorn_init.sh /etc/init.d/unicorn

# Place custom nginx configs here
COPY config/nginx-${RAILS_ENV}-site.conf /etc/nginx/sites-enabled/default
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure supervisor
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add and Run setup script. This sets up the tmp folder and symlinks it to shared
COPY scripts/setup.sh /etc/my-app/setup.sh
COPY scripts/startup.sh /etc/my-app/startup.sh

RUN /etc/my-app/setup.sh

# Expose port 80
EXPOSE 80

# CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
CMD ["sh", "-c", "/etc/my-app/startup.sh"]
