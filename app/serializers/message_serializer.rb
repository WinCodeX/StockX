class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :read, :user_id, :conversation_id, :created_at

  belongs_to :user, serializer: UserSerializer
end