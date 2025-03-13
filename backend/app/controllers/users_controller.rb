class UsersController < ApplicationController
  before_action :authenticate_user, only: %i[update]

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

  # PATCH /users/:id
  def update
    user = User.find(params[:id])

    return unless authorize_user!(user)

    if user.update(user_update_params)
      render json: { email: user.email }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:email)
  end
end
