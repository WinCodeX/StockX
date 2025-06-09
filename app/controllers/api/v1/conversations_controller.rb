module Api module V1 class ConversationsController < ApplicationController 
before_action :authenticate_user!

def index
    conversations = Conversation
      .where("sender_id = ? OR receiver_id = ?", current_user.id, current_user.id)
      .includes(:sender, :receiver, messages: :user)
      .order(updated_at: :desc)

    render json: conversations.map { |c| conversation_json(c) }, status: :ok
  end

  def create
    recipient_id = params[:receiver_id]
    existing = Conversation.between(current_user.id, recipient_id).first

    if existing
      render json: conversation_json(existing), status: :ok
    else
      conversation = Conversation.new(sender_id: current_user.id, receiver_id: recipient_id)
      if conversation.save
        render json: conversation_json(conversation), status: :created
      else
        render json: { error: conversation.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def show
    conversation = Conversation.find(params[:id])
    if conversation.sender == current_user || conversation.receiver == current_user
      render json: conversation_json(conversation, full: true), status: :ok
    else
      render json: { error: "Access denied" }, status: :forbidden
    end
  end

  private

  def conversation_json(convo, full: false)
    {
      id: convo.id,
      sender: {
        id: convo.sender.id,
        name: convo.sender.name
      },
      receiver: {
        id: convo.receiver.id,
        name: convo.receiver.name
      },
      messages: full ? convo.messages.order(created_at: :asc).map do |m|
        {
          id: m.id,
          body: m.body,
          read: m.read,
          user_id: m.user_id,
          created_at: m.created_at
        }
      end : [],
      last_updated: convo.updated_at
    }
  end
end

end end

