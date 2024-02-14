class ChatCreationJob
  include Sidekiq::Job

  def perform(application_id, chat_number)
    Chat.create!(my_application_id: application_id, number: chat_number)
  end
end
