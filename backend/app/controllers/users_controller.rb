class UsersController < ApplicationController
  # POST /users
  def create
    result, data = UserCreator.call(user_params)

    case result
    when :user_saved
      render json: data, status: :created
    when :email_taken
      render json: { error: "Email address is already in use" }, status: :conflict
    when :validation_error
      render json: { errors: data }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
