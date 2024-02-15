class UpdateChatsCounterJob
  include Sidekiq::Job
    
    # UPDATE `my_applications`
    #  JOIN (
    #     SELECT my_application_id, COUNT(id) as chat_count
    #     FROM `chats`
    #     GROUP BY `chats`.`my_application_id`
    #     ) as chat_subquery ON my_applications.id = chat_subquery.my_application_id
    #  SET chats_count = COALESCE(chat_subquery.chat_count, 0)

    def perform
      # Use a subquery to get the counts and then update the main table
      chat_subquery = Chat
      .select('my_application_id, COUNT(id) as chat_count')
      .group(:my_application_id)
      .to_sql

      MyApplication
      .joins("JOIN (#{chat_subquery}) as chat_subquery ON my_applications.id = chat_subquery.my_application_id")
      .update_all('chats_count = COALESCE(chat_subquery.chat_count, 0)')

      # MyApplication.all.each do |application|
      #   id = application.id
      #   chats_count = $redis.get("chats_count&#{id}").to_i
      #   application.update(chats_count: chats_count)
      # end
  
  end
end