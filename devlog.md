# Day 1

```bash
rails new Chat-On-Rails --api --database=mysql
```
[Wait for MySQL to be ready](https://stackoverflow.com/questions/42567475/docker-compose-check-if-mysql-connection-is-ready)

# Day 2

> same shit plus

```docker
command: rails s -b 0.0.0.0
```

```ruby
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV.fetch("DB_USER") %>
  password: <%= ENV.fetch("DB_PASSWORD") %>
  host: <%= ENV.fetch("DB_HOST") %>
  socket: /var/run/mysqld/mysqld.sock
```
- [rails  | A server is already running](https://stackoverflow.com/questions/29181032/add-a-volume-to-docker-but-exclude-a-sub-folder)