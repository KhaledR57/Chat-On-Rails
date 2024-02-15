class UpdateMessagesCounterJob
  include Sidekiq::Job

    # UPDATE `chats`
    #  JOIN (
    #     SELECT chat_id, COUNT(id) as message_count
    #     FROM `messages`
    #     GROUP BY `messages`.`chat_id`
    #     ) as message_subquery ON chats.id = message_subquery.chat_id
    #  SET messages_count = COALESCE(message_subquery.message_count, 0)

    def perform
      # Use a subquery to get the counts and then update the main table
      message_subquery = Message
      .select('chat_id, COUNT(id) as message_count')
      .group(:chat_id)
      .to_sql

      Chat
      .joins("JOIN (#{message_subquery}) as message_subquery ON chats.id = message_subquery.chat_id")
      .update_all('messages_count = COALESCE(message_subquery.message_count, 0)')

      # Chat.all.each do |chat|
      #   id = chat.id
      #   messages_count = $redis.get("messages_count&#{id}").to_i
      #   chat.update(messages_count: messages_count)
      # end

  end
end
