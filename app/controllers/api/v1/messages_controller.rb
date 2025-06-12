class Api::V1::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  # GET /api/v1/conversations/:conversation_id/messages
  def index
    messages = @conversation.messages.includes(:user).order(:created_at)
    render json: MessageSerializer.new(messages, include: [:user]).serialized_json, status: :ok
  end

  # POST /api/v1/conversations/:conversation_id/messages
  def create
    unless [@conversation.sender_id, @conversation.receiver_id].include?(current_user.id)
      return render json: { error: 'You are not a participant of this conversation.' }, status: :forbidden
    end

    message = @conversation.messages.build(message_params.merge(user_id: current_user.id))

    if message.save
      render json: MessageSerializer.new(message, include: [:user]).serialized_json, status: :created
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find_by(id: params[:conversation_id])
    render json: { error: 'Conversation not found' }, status: :not_found unless @conversation
  end

  def message_params
    params.require(:message).permit(:body)
  end
end