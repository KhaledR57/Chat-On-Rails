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
    if @message
      render json: @message
    else
      render json: { error: 'Could not find message' }, status: :not_found
    end
  end

  # POST /api/v1/messages
  def create
    @message = Message.new(chat_id: @chat.id, body: params[:body])

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
    if @message&.destroy
      head :no_content
    else
      render json: { error: 'Could not delete message'  }, status: 422
    end
  end

  def search
    messages = Message.search(@chat.id, params[:query]).as_json(only: [:number, :body, :created_at, :updated_at])
    render json: {messages:  messages}, status: :ok
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
      params.require(:message).permit(:body)
    end
end
