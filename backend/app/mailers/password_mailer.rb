class PasswordMailer < ApplicationMailer
  default from: "office@newgillianger.com"

  def reset_password_email
    user = params[:user]
    @reset_token = user.reset_password_token

    mail(to: user.email, subject: "Newgillianger password reset")
  end
end
