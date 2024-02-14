class UpdateMessagesCounterJob
  include Sidekiq::Job

    def perform
      Chat.all.each do |chat|
      id = chat.id
      messages_count = $redis.get("messages_count&#{id}").to_i
      chat.update(messages_count: messages_count)
    end
  end
end
