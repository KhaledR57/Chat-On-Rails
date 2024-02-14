class UpdateChatsCounterJob
    include Sidekiq::Job
    
    def perform
      MyApplication.all.each do |application|
      id = application.id
      chats_count = $redis.get("chats_count&#{id}").to_i
      application.update(chats_count: chats_count)
    end
  end
end