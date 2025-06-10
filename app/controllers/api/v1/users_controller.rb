module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!

      def search
        query = params[:q].to_s.strip
        if query.present?
          users = User.lookup(query) # Using the lookup method to search users
          render json: users, status: :ok
        else
          render json: [], status: :ok
        end
      end
    end
  end
end