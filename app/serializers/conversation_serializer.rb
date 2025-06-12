# app/serializers/conversation_serializer.rb
class ConversationSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id

  belongs_to :sender, serializer: UserSerializer
  belongs_to :receiver, serializer: UserSerializer

  attribute :lastMessage do |object|
    last = object.messages.order(created_at: :desc).first
    if last
      {
        body: last.body,
        created_at: last.created_at
      }
    else
      nil
    end
  end
end