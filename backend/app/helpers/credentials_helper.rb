module CredentialsHelper
  def jwt_secret_key
    if Rails.env.test?
      "0"*128
    else
      ENV["CREDENTIALS_SECRET_KEY"]
    end
  end
end
