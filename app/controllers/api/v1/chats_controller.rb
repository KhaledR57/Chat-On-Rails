class Api::V1::ChatsController < ApplicationController
  before_action :set_my_application
  before_action :set_chat, only: %i[ show update destroy ]

  # GET /api/v1/chats
  def index
    @chats = @my_application.chats.all

    render json: @chats
  end

  # GET /api/v1/chats/1
  def show
    if @chat
      render json: @chat
    else
      render json: { error: 'Could not find chat' }, status: :not_found
    end
  end

  # POST /api/v1/chats
  def create
    @chat = Chat.new(my_application_id: @my_application.id)

    if @chat.save
      render json: @chat, status: :created
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/chats/1
  def update
    if @chat.update(number: params[:number])
      render json: @chat
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/chats/1
  def destroy
    if @chat&.destroy
      head :no_content
    else
        render json: { error: 'Could not delete chat' }, status: 422
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = @my_application.chats.find_by_number(params[:chat_number])
    end

    def set_my_application
      @my_application = MyApplication.find_by_token(params[:my_application_token])
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:my_application_token)
    end
end
