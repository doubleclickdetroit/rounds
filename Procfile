web:          bundle exec thin start -R config.ru -e $RAILS_ENV -p $PORT

redis_server: redis-server
resque:       bundle exec rake resque:work QUEUE='*'
scheduler:    bundle exec rake resque:scheduler

private_pub:  rackup private_pub.ru -s thin -E production
