class Chat < ApplicationRecord
  belongs_to :my_application


  #  TODO: validata body
  has_many :messages

  before_create :set_number

  private

  def set_number
    transaction do
      last_chat = my_application.chats.order(number: :desc).first
      self.number = last_chat ? last_chat.number + 1 : 1
    end
  end
end
