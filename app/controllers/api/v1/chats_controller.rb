class Api::V1::ChatsController < ApplicationController
  before_action :set_my_application
  before_action :set_chat, only: %i[ show update destroy ]

  # GET /api/v1/chats
  def index
    response = ""
    page = params[:page] || 0   
    rkey = "#{page}_chats"
    
    if $redis.exists(rkey) != 0
      # puts "cached"
      response = $redis.get(rkey)
    else
      @messages = page == 0 ? @my_application.chats.all : @my_application.chats.page(page)
      response = JSON.dump(@messages.as_json(only: [:number, :body]))
      $redis.set(rkey, response)
      $redis.expire(rkey, 30.minutes.to_i)
    end

    render json: response
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
    incr_chat_count(@my_application.id)
    chat_number = get_chat_num(params[:my_application_token])
    
    # Queue the message creation
    ChatCreationJob.perform_async(@my_application.id, chat_number)

    render json: { application_token: params[:my_application_token], chat_number: chat_number }, status: :accepted
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
    @chat.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = @my_application.chats.find_by_number(params[:number])
      @chat || (render json: { error: 'Could not find chat!' }, status: :not_found)
    end

    def set_my_application
      @my_application = MyApplication.find_by_token(params[:my_application_token])
      @my_application || (render json: { error: 'Could not find application!' }, status: :not_found)
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:my_application_token)
    end

    def get_chat_num(application_token)
      $redis.incr("chat_counter&#{application_token}")
    end

    def incr_chat_count(application_id)
      $redis.incr("chats_count&#{application_id}")
    end
end
