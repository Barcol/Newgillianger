class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, length: { maximum: 255 }
  validates :password_confirmation, presence: true, if: -> { password.present? }
end
