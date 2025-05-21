# app/serializers/user_serializer.rb
class UserSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :email, :username

  attribute :avatar_url do |user|
    if user.avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(user.avatar, only_path: true)
    else
      nil
    end
  end
end