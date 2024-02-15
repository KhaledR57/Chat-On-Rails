class Api::V1::MessagesController < ApplicationController
  
  before_action :set_chat
  before_action :set_message, only: %i[ show update destroy ]

  # GET /api/v1/messages
  def index
    response = ""
    page = params[:page] || 0   
    rkey = "#{page}_messages"
    
    if $redis.exists(rkey) != 0
      # puts "cached"
      response = $redis.get(rkey)
    else
      @messages = page == 0 ? @chat.messages.all : @chat.messages.page(page)
      response = JSON.dump(@messages.as_json(only: [:number, :body]))
      $redis.set(rkey, response)
      $redis.expire(rkey, 30.minutes.to_i)
    end

    render json: response
  end

  # GET /api/v1/messages/1
  def show
    if @message
      render json: @message.as_json(only: [:number, :body])
    else
      render json: { error: 'Could not find message' }, status: :not_found
    end
  end

  # POST /api/v1/messages
  def create
    incr_message_count(@chat.id)
    message_number = get_message_num(params[:my_application_token], params[:chat_number])
    # Queue the message creation
    MessageCreationJob.perform_async(@chat.id, params[:body], message_number)
    # Sidekiq::Client.push "class" => "MyGoWorker", "args" => [@chat.id, params[:body], message_number]

    render json: { body: params[:body], message_number: message_number }, status: :accepted
  end

  # PATCH/PUT /api/v1/messages/1
  def update
    if @message.update(message_params)
      render json: @message.as_json(only: [:number, :body])
    else
      render json: { errors: @message.errors } , status: :unprocessable_entity
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
    result = Message.search(@chat.id, params[:query]).as_json(only: [:number, :body])
    render json: {messages:  result}, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = @chat.messages.find_by_number(params[:id])
      @message || (render json: { error: 'Could not find message!' }, status: :not_found) 
    end

    def set_chat
      @chat = Chat.includes(:my_application).find_by(my_applications: { token: params[:my_application_token] }, number: params[:chat_number])
      @chat || (render json: { error: 'Could not find chat!' }, status: :not_found)
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:body)
    end

    def get_message_num(application_token, chat_number)
      $redis.incr("message_counter&#{chat_number}&#{application_token}")
    end

    def incr_message_count(chat_id)
      $redis.incr("messages_count&#{chat_id}")
    end
end
