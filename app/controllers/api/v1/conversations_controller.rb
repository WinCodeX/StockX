module Api
  module V1
    class ConversationsController < ApplicationController
      before_action :authenticate_user!

      # GET /api/v1/conversations
      def index
        conversations = Conversation
          .where("sender_id = ? OR receiver_id = ?", current_user.id, current_user.id)
          .includes(:sender, :receiver, messages: :user)
          .order(updated_at: :desc)

        render json: conversations.map { |c| serialize_conversation(c) }, status: :ok
      end

      # POST /api/v1/conversations
      def create
        recipient_id = params[:receiver_id]

        # Search for existing conversation
        conversation = Conversation.between(current_user.id, recipient_id).first

        if conversation
          render json: serialize_conversation(conversation), status: :ok
        else
          conversation = Conversation.new(sender_id: current_user.id, receiver_id: recipient_id)
          if conversation.save
            render json: serialize_conversation(conversation), status: :created
          else
            render json: { error: conversation.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end

      # GET /api/v1/conversations/:id
      def show
        conversation = Conversation.find(params[:id])

        unless [conversation.sender_id, conversation.receiver_id].include?(current_user.id)
          return render json: { error: "Access denied" }, status: :forbidden
        end

        render json: serialize_conversation(conversation, full: true), status: :ok
      end

      private

      def serialize_conversation(convo, full: false)
  {
    id: convo.id,
    sender: {
      id: convo.sender.id,
      username: convo.sender.username
    },
    receiver: {
      id: convo.receiver.id,
      username: convo.receiver.username
    },
    messages: full ? convo.messages.order(:created_at).map do |m|
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
  end
end