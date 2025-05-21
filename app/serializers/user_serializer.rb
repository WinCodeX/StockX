class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :avatar_url

  def avatar_url
    object.avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.avatar, only_path: true) : nil
  end
end