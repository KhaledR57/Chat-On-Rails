module SearchableMessage
    extend ActiveSupport::Concern
  
    included do
      include Elasticsearch::Model
      include Elasticsearch::Model::Callbacks
  
      mapping do
        indexes :chat_id, type: 'keyword'
        indexes :body, type: 'text', analyzer: 'english'
      end
  
      def self.search(query)
        params = {
            query: {
                bool: {
                    must: {
                        term: {
                            chat_id => chat.id
                        }
                    },
                    filter: {
                        multi_match: {
                            query: query,
                            fields: ['body'],
                        }
                    },
                },
            }
        }

        self.__elasticsearch__.search(params).records
      end
    end
  end