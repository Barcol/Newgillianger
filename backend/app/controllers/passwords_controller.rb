class PasswordsController < ApplicationController
  def request_password_reset
    result = PasswordResetTokenService.call(params[:email])

    case result
    when :success
      render json: { message: "If the email exists, we have sent password reset instructions." }, status: :ok
    when :error_saving_token
      render json: { error: "An error occurred while generating the reset token." }, status: :unprocessable_entity
    else
      render json: { message: "If the email exists, we have sent password reset instructions." }, status: :ok
    end
  end

  def reset
    result = ResetPasswordService.call(params[:token], params[:password], params[:password_confirmation])

    case result
    when :success
      render json: { message: "Password has been successfully changed." }, status: :ok
    when :passwords_do_not_match
      render json: { error: "Passwords do not match." }, status: :unprocessable_entity
    when :password_too_short
      render json: { error: "Password is too short." }, status: :unprocessable_entity
    when :password_too_long
      render json: { error: "Password is too long" }, status: :unprocessable_entity
    when :invalid_token
      render json: { error: "Invalid token." }, status: :unprocessable_entity
    when :expired_token
      render json: { error: "Expired token." }, status: :unprocessable_entity
    else
      render json: { error: "An error occurred while updating the password." }, status: :unprocessable_entity
    end
  end
end
