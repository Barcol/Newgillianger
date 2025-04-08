class PasswordResetTokenService < BaseService
  def initialize(user_email)
    @user_email = user_email
  end

  def self.call(user_email)
    new(user_email).call
  end

  def call
    user = User.find_by(email: @user_email)
    return :user_not_found unless user

    if generate_password_reset_token(user)
      PasswordMailer.with(user: user).reset_password_email.deliver_later
      :success
    else
      :error_saving_token
    end
  end

  private

  def generate_password_reset_token(user)
    user.update(
      reset_password_token: SecureRandom.hex(20),
      reset_password_sent_at: Time.current
    )
  end
end
