class Message < ApplicationRecord
  include SearchableMessage
  
  belongs_to :chat

  validates :body, presence: true

  # T3ml 2l2 de le elastic fantastic
  # def as_json(options = nil)
  #   super(only: [:number, :body])
  # end
end
