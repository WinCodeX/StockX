# app/serializers/conversation_serializer.rb
class ConversationSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :updated_at

  attribute :sender do |obj|
    {
      id: obj.sender.id,
      username: obj.sender.username
    }
  end

  attribute :receiver do |obj|
    {
      id: obj.receiver.id,
      username: obj.receiver.username
    }
  end

  attribute :messages do |obj, params|
    if params[:full]
      obj.messages.order(:created_at).map do |m|
        {
          id: m.id,
          body: m.body,
          read: m.read,
          user_id: m.user_id,
          created_at: m.created_at
        }
      end
    else
      []
    end
  end
end