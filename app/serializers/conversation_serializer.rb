class ConversationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :updated_at

  attribute :sender do |obj|
    {
      id: obj.sender.id,
      username: obj.sender.username,
      avatar_url: obj.sender.avatar.attached? ?
        Rails.application.routes.url_helpers.rails_blob_url(obj.sender.avatar, only_path: false) : nil
    }
  end

  attribute :receiver do |obj|
    {
      id: obj.receiver.id,
      username: obj.receiver.username,
      avatar_url: obj.receiver.avatar.attached? ?
        Rails.application.routes.url_helpers.rails_blob_url(obj.receiver.avatar, only_path: false) : nil
    }
  end

  attribute :messages do |obj|
    obj.messages.order(created_at: :asc).map do |m|
      {
        id: m.id,
        body: m.body,
        read: m.read,
        user_id: m.user_id,
        created_at: m.created_at
      }
    end
  end
end