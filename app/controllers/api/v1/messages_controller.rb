class Api::V1::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  # GET /api/v1/conversations/:conversation_id/messages
  def index
    @messages = @conversation.messages.order(:created_at)
    render json: @messages, include: ['user']
  end

  # POST /api/v1/conversations/:conversation_id/messages
  def create
    # Ensure that the current user is part of the conversation
    if !@conversation.users.include?(current_user)
      return render json: { error: 'You are not a participant of this conversation.' }, status: :forbidden
    end

    @message = @conversation.messages.new(message_params.merge(user_id: current_user.id))

    if @message.save
      # Optionally, you can broadcast this message to the chat in real-time using ActionCable
      render json: @message, status: :created, include: ['user']
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Conversation not found' }, status: :not_found
  end

  def message_params
    params.require(:message).permit(:content)
  end
end