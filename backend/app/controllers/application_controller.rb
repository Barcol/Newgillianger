class ApplicationController < ActionController::API
  private

  attr_reader :current_user

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

  def authorize_user!(record)
    return render_forbidden unless authorized?(record)

    true
  end

  def authorized?(user)
    return user.id == current_user.id if user.is_a?(User)
    false
  end

  def render_forbidden
    render json: { error: "Forbidden" }, status: :forbidden
    false
  end
end
