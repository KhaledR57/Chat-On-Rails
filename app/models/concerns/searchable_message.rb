module SearchableMessage
    extend ActiveSupport::Concern
  
    included do
        include Elasticsearch::Model
        include Elasticsearch::Model::Callbacks
  

        # Every time our entry is created, updated, or deleted, we update the index accordingly.
        # after_commit on: %i[create update] do
        #     __elasticsearch__.index_document
        # end
  
        # after_commit on: %i[destroy] do
        #     __elasticsearch__.delete_document
        # end

        self.__elasticsearch__.create_index!
        self.__elasticsearch__.refresh_index!
  
        settings index: { number_of_shards: 1 } do
            mappings dynamic: false do
            # the chat_id must be of the keyword type since we're only going to use it to filter messages.
            indexes :chat_id, type: :keyword
            indexes :body, type: :text, analyzer: :english
            end
        end
  
      
      def self.search(chat_id, query)
        params = {
            query: {
                bool: {
                    must: {
                        term: {
                            chat_id: chat_id
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

        self.import
        self.__elasticsearch__.search(params).records
      end
    end
  end