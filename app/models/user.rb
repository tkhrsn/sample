class User < ApplicationRecord

  # メールアドレスは登録前に小文字に変換する
  before_save { self.email = email.downcase }

  # メールアドレスのformatを検証するための正規表現
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
end
