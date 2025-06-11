class Api::V1::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  # GET /api/v1/conversations/:conversation_id/messages
  def index
    @messages = @conversation.messages.includes(:user).order(:created_at)
    render json: @messages, include: ['user']
  end

  # POST /api/v1/conversations/:conversation_id/messages
  def create
    unless @conversation.users.include?(current_user)
      return render json: { error: 'You are not a participant of this conversation.' }, status: :forbidden
    end

    @message = @conversation.messages.build(message_params.merge(user_id: current_user.id))

    if @message.save
      # Optionally broadcast via ActionCable (real-time chat)
      # ChatChannel.broadcast_to(@conversation, @message)
      render json: @message, status: :created, include: ['user']
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find_by(id: params[:conversation_id])

    unless @conversation
      render json: { error: 'Conversation not found' }, status: :not_found
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end