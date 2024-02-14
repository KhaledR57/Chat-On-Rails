Elasticsearch::Model.client = Elasticsearch::Client.new(
  port: ENV.fetch('ES_PORT') { 9200 },
  host: ENV.fetch('ES_HOST') { 'elasticsearch' }
)