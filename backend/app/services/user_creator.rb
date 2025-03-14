class UserCreator < BaseService
  def initialize(user_params)
    @user_params = user_params
  end

  def call
    return [ :email_taken, nil ] if existing_user?

    create_user
  end

  private

  attr_reader :user_params

  def existing_user?
    User.exists?(email: user_params[:email])
  end

  def validate(user)
    user.validate

    password = user_params[:password]
    password_confirmation = user_params[:password_confirmation]

    user.errors.add(:password, "is too short (minimum is 8 characters)") if password.length < 8
    user.errors.add(:password, "is too long (maximum is 70 characters)") if password.length > 70
    user.errors.add(:password_confirmation, "can't be blank") if password_confirmation&.blank?
  end

  def create_user
    user = User.new(user_params)

    validate(user)

    return [ :validation_error, user.errors ] if user.errors.any?

    [ :user_saved, user ] if user.save
  end
end
