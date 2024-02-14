class MessageCreationJob
  include Sidekiq::Job

  def perform(chat_id, body, message_number)
    Message.create!(chat_id: chat_id, body: body, number: message_number)
  end
end
