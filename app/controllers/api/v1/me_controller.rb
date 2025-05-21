module Api
  module V1
    class MeController < ApplicationController
      before_action :authenticate_user!

      include Rails.application.routes.url_helpers

def show
  render json: UserSerializer.new(current_user).serializable_hash
end

      def update_avatar
        if current_user.update(avatar: params[:avatar])
          render json: {
            message: 'Avatar updated successfully',
            avatar: current_user.avatar
          }
        else
          render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end