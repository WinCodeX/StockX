# app/serializers/user_serializer.rb
class UserSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :email, :username

  attribute :avatar_url do |user|
    if user.avatar.attached?
      Rails.application.routes.url_helpers.rails_representation_url(
  user.avatar.variant(resize_to_fill: [60, 60]).processed,
  only_path: false
)
    else
      nil
    end
  end
end