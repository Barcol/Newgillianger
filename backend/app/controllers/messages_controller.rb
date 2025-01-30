class MessagesController < ApplicationController
  def hello
    render json: { message: "hello world" }
  end
end
