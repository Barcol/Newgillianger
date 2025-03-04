class UserCreator < BaseService
  def initialize(user_params)
    @user_params = user_params
  end

  def call
    if existing_user?
      [ :email_taken, nil ]
    else
      create_user
    end
  end

  private

  attr_reader :user_params

  def existing_user?
    User.exists?(email: user_params[:email])
  end

  def create_user
    user = User.new(user_params)
    if user.save
      [ :user_saved, user ]
    else
      [ :validation_error, user.errors ]
    end
  end
end
