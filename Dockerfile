FROM jaicob/rails-nginx-unicorn
MAINTAINER jaicob(jaicob@icloud.com)

WORKDIR /home/rails/my-app 

# Place custom unicorn configs here
ADD config/unicorn.rb /etc/my-app/config/unicorn.rb
					
# ADD unicorn_init.sh /etc/init.d/unicorn

# Place custom nginx configs here
# COPY nginx-app-site.conf /etc/nginx/sites-enabled/default
# COPY nginx.conf /etc/nginx/nginx.conf

# Add custom setup script here TODO change name to setup.sh
COPY setup.sh /etc/my-app/setup.sh

# Run setup script. This sets up the tmp folder and symlinks it to shared
# as well as sets up the database if necessary
RUN /etc/my-app/setup.sh

# Expose port 80
EXPOSE 80

# Set environment 
ENV RAILS_ENV production

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
