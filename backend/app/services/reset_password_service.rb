class ResetPasswordService < BaseService
  def initialize(token, password, password_confirmation)
    @token = token
    @password = password
    @password_confirmation = password_confirmation
  end

  def call
    user = User.find_by(reset_password_token: @token)
    return :invalid_or_expired_token unless user&.password_reset_token_valid?

    validation_error = validate_password
    return validation_error if validation_error

    reset_password(user)
  end

  private

  def validate_password
    return :password_too_short if @password.length < 8
    return :password_too_long if @password.length > 70
    return :passwords_do_not_match unless @password == @password_confirmation
  end

  def reset_password(user)
    if user.update(password: @password, reset_password_token: nil, reset_password_sent_at: nil)
      :success
    else
      :error_saving_password
    end
  end
end
