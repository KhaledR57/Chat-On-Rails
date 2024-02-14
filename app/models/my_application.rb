class MyApplication < ApplicationRecord
    before_create :random_token

    has_many :chats

    validates :name, presence: true
    
    private

    # TODO: retry if failed
    def random_token()
        self.token = SecureRandom.urlsafe_base64(nil, false)
    end
end
