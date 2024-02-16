class MyApplication < ApplicationRecord
    before_create :random_token

    has_many :chats, dependent: :destroy

    validates :name, presence: true

    def as_json(options = nil)
        super(only: [:name, :token, :chats_count])
    end
      
    private
    # TODO: retry if failed
    def random_token()
        self.token = SecureRandom.urlsafe_base64(nil, false)
    end
end
