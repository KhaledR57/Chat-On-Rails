class Message < ApplicationRecord
  belongs_to :chat

  before_create :set_number

  private

  def set_number
    transaction do
      last_message = chat.messages.order(number: :desc).first
      self.number = last_message ? last_message.number + 1 : 1
    end
  end
end
