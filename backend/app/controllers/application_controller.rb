class ApplicationController < ActionController::API
  private

  def authenticate_user
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    begin
      secret_key = ENV["CREDENTIALS_SECRET_KEY"]
      decoded = JWT.decode(token, secret_key)[0]
      @current_user = User.find(decoded["user_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end