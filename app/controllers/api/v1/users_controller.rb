module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user! # optional if needed

      def search
        query = params[:q].to_s.strip.downcase
        if query.present?
          users = User
                    .where('LOWER(username) LIKE ?', "%#{query}%")
                    .limit(10)
          render json: users, status: :ok
        else
          render json: [], status: :ok
        end
      end
    end
  end
end