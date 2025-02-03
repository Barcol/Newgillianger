class MessagesController < ApplicationController
  def hello
    logger.info "Received request at #{Time.now}"
    render json: { content: "Hello World, request time: #{Time.now}" }
  end
end
