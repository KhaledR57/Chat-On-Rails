class Api::V1::MessagesController < ApplicationController
  before_action :set_my_application
  before_action :set_chat
  before_action :set_message, only: %i[ show update destroy ]

  # GET /api/v1/messages
  def index
    @messages = @chat.messages.all

    render json: @messages
  end

  # GET /api/v1/messages/1
  def show
    render json: @message
  end

  # POST /api/v1/messages
  def create
    @message = Message.new(chat_id: @chat.id)

    if @message.save
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/messages/1
  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/messages/1
  def destroy
    @message.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = @chat.messages.find_by_number(params[:id])
    end

    def set_chat
      @chat = Chat.find_by(my_application: @my_application.id, number: params[:chat_number])
    end

    def set_my_application
      @my_application = MyApplication.find_by_token(params[:my_application_token])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:number, :body, :chat_id)
    end
end
