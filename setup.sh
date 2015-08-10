RAILS_ENV=$RAILS_ENV
: ${RAILS_ENV:="development"}
export RAILS_ENV

SECRET_KEY_BASE=$SECRET_KEY_BASE
: ${SECRET_KEY_BASE:="f38c575fcf0b2a0e7c7f002a873d54d78104581ebe069bf2b1afad04014d1e10245b259b872b0e12189ef2ce3fca4c73a9b5103aaf4aad1f4"}
export SECRET_KEY_BASE=$SECRET_KEY_BASE

## Setting DB
DB_NAME="my_app_${RAILS_ENV}"

# Trap sigkill and sigterm: otherwise dockr stop/start will complain for stale unicorn pid
trap "pkill unicorn_rails ; exit " SIGINT SIGTERM SIGKILL

echo "Stopping  unicorn_rails, if already running"
pkill unicorn_rails

#TODO Only run if environment is production
echo "Setting up tmp and shared directories & removing old pids"
rm -rf ./tmp/pids && \
rm -rf ./tmp/sessions && \
rm -rf ./tmp/sockets && \
mkdir ./shared && \
mkdir ./tmp/pids && \
mkdir ./tmp/sessions && \
mkdir ./tmp/sockets && \
ln -s /home/rails/my-app/tmp/cache /home/rails/my-app/shared/cache && \
ln -s /home/rails/my-app/tmp/pids /home/rails/my-app/shared/pids && \
ln -s /home/rails/my-app/tmp/sessions /home/rails/my-app/shared/sessions && \
ln -s /home/rails/my-app/tmp/sockets /home/rails/my-app/shared/sockets && \
ln -s /home/rails/my-app/log /home/rails/my-app/shared/log


echo "Preparing the gems"
bundle install
bundle binstubs unicorn
rbenv rehash
rake bower:install
RAILS_ENV=production bundle exec rake assets:precompile --trace


echo "Setting up database"
rake db:create db:migrate

# echo "Running unicorn"

#bundle exec unicorn -c /etc/my-app/unicorn.rb -E $RAILS_ENV --debug
