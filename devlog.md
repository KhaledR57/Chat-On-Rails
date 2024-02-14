# Day 1

```bash
rails new Chat-On-Rails --api --database=mysql
```
~~[Wait for MySQL to be ready](https://stackoverflow.com/questions/42567475/docker-compose-check-if-mysql-connection-is-ready)~~

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

#### I made MySQL docker image start faster and no need to wait for the image to be ready ***I used volumes :)***

# Day 3

Nothing 

# Day 4

```bash
rails generate scaffold MyApplication name:string token:string:uniq chats_count:integer
rails generate scaffold Chat number:integer messages_count:integer my_application:references
rails generate scaffold Message number:integer messages_count:integer body:text chat:references
```

### Elastic search
[Good tut](https://medium.com/simform-engineering/full-text-search-with-elasticsearch-in-rails-6e58a92211c5)

```
Mapping numeric identifiers

Not all numeric data should be mapped as a numeric field data type. Elasticsearch optimizes numeric fields, such as integer or long, for range queries. However, keyword fields are better for term and other term-level queries.

Identifiers, such as an ISBN or a product ID, are rarely used in range queries. However, they are often retrieved using term-level queries.

Consider mapping a numeric identifier as a keyword if:

    You don’t plan to search for the identifier data using range queries.
    Fast retrieval is important. term query searches on keyword fields are often faster than term searches on numeric fields.

If you’re unsure which to use, you can use a multi-field to map the data as both a keyword and a numeric data type.
```

TODO: join tables


[route problemaaaa](https://stackoverflow.com/questions/13064844/rails-routing-on-collection)

[I love this man](https://tihandev.com/how-to-integrate-elasticsearch-with-ruby-on-rails/)

[And this issue](https://github.com/elastic/elasticsearch-rails/issues/768)