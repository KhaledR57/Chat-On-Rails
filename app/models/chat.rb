class Chat < ApplicationRecord
  belongs_to :my_application

  has_many :messages, dependent: :destroy

  def as_json(options = nil)
    super(only: [:number, :messages_count])
  end
end
