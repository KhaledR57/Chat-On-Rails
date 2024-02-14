class Message < ApplicationRecord
  include SearchableMessage
  
  belongs_to :chat

  validates :body, presence: true

  before_create :set_number

  private

  def set_number
      last_message = Message.where(chat_id: self.chat_id).order(number: :desc).first
      self.number = last_message ? last_message.number + 1 : 1
  end
end
