FROM jaicob/rails-nginx-unicorn:onbuild
MAINTAINER jaicob(jaicob@icloud.com)

# Install app
# RUN sudo rm -rf /home/rails/my-app/*
# ADD . /home/rails/my-app
# WORKDIR /home/rails/my-app
# RUN chown -R rails /home/rails/my-app
# USER rails

# add gems
# RUN \
# 	bundle install && \
# 	rbenv rehash && \
# 	RAILS_ENV=production bundle exec rake assets:precompile --trace

# Add unicorn config here 
# ADD ./config/unicorn.rb /etc/my-app/unicorn.rb
# ADD ./unicorn /etc/init.d/unicorn

#Add Run script
# ADD ./run.sh /etc/my-app/run.sh

# Set environment 
ENV RAILS_ENV development

# Expose port 80
EXPOSE 80

# Set default run command
ENTRYPOINT /bin/bash /etc/my-app/app_entrypoint.sh