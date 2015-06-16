FROM jaicob/rails-nginx-unicorn:base
MAINTAINER jaicob(jaicob@icloud.com)
#RUN apt-get update -qq && apt-get install -y build-essential nodejs npm nodejs-legacy vim

# Install Nginx.
#RUN echo "deb http://archive.ubuntu.com/ubuntu/ raring main universe" >> /etc/apt/sources.list
#RUN apt-get update
#RUN apt-get -y --force-yes --fix-missing install  python3-software-properties
#RUN add-apt-repository -y ppa:nginx/stable

#RUN apt-get install -qq -y nginx
#RUN rm -v /etc/nginx/nginx.conf

#RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx

# Add default nginx config
ADD nginx-sites.conf /etc/nginx/sites-enabled/default
#RUN service nginx reload && service nginx restart

# for postgres
#RUN apt-get install -y libpq-dev

# for nokogiri
#RUN apt-get install -y libxml2-dev libxslt1-dev

# for capybara-webkit
#RUN apt-get install -y libqt4-webkit libqt4-dev xvfb


# RUN mkdir /home/rails/web-app

# RUN \
#       echo 'rails ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
#   &&  groupadd rails \
#   &&  useradd rails -m -g rails -g sudo \
#   && chown -R rails /web-app



#get gems
# WORKDIR /web-app
# COPY Gemfile Gemfile
# RUN chown rails:rails Gemfile
# COPY Gemfile.lock Gemfile.lock
# RUN chown rails:rails Gemfile.lock
# RUN bundle install

# RUN bundle install
# RUN rbenv rehash

#install app

RUN mkdir /home/rails/web-app
ADD . /home/rails/web-app
WORKDIR /home/rails/web-app
RUN chown -R rails /home/rails/web-app
USER rails

RUN bundle install
RUN rbenv rehash
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace

# Add unicorn config here 
ADD ./config/unicorn.rb /etc/web-app/unicorn.rb
ADD ./unicorn /etc/init.d/unicorn

#Add Run script
ADD ./run.sh /etc/web-app/run.sh

# Set environment variables
ENV RAILS_ENV development

EXPOSE 80
CMD /bin/bash /etc/web-app/run.sh