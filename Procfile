web:          bundle exec rails server
redis_server: redis-server
private_pub:  rackup private_pub.ru -s thin -E production
resque:       bundle exec rake resque:work QUEUE='*'
scheduler:    bundle exec rake resque:scheduler
