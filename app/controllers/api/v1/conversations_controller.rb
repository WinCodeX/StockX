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

        render json: ConversationSerializer.new(conversations, params: { full: false }).serialized_json, status: :ok
      end

      # POST /api/v1/conversations
      def create
        recipient_id = params[:receiver_id]
        conversation = Conversation.between(current_user.id, recipient_id).first

        if conversation
          render json: ConversationSerializer.new(conversation, params: { full: false }).serialized_json, status: :ok
        else
          conversation = Conversation.new(sender_id: current_user.id, receiver_id: recipient_id)
          if conversation.save
            render json: ConversationSerializer.new(conversation, params: { full: false }).serialized_json, status: :created
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

        render json: ConversationSerializer.new(conversation, params: { full: true }).serialized_json, status: :ok
      end
    end
  end
end