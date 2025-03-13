class ApplicationController < ActionController::API
  private

  def authenticate_user
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    begin
      secret_key = Rails.application.config.credentials_secret_key
      decoded = JWT.decode(token, secret_key)[0]
      @current_user = User.find(decoded["user_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def authorize_user!(record)
    authorized = if record.is_a?(User)
      record.id == current_user.id
    else
      record.user_id == current_user.id
    end

    unless authorized
      render json: { error: "Forbidden" }, status: :forbidden
      false
    else
      true
    end
  end
end
