# app/serializers/message_serializer.rb
class MessageSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :body, :read, :created_at, :user_id

  belongs_to :user, serializer: UserSerializer
end