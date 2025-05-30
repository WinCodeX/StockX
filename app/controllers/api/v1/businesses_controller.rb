module Api
  module V1
    class BusinessesController < ApplicationController
      before_action :authenticate_user!

      def create
        business = Business.new(business_params)
        business.owner = current_user

        if business.save
          render json: { success: true, business: business }, status: :created
        else
          render json: { success: false, errors: business.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def index
        businesses = current_user.user_businesses.includes(:business).map(&:business)
        render json: businesses, status: :ok
      end

      def show
        business = Business.find(params[:id])
        if business.owner == current_user || business.users.include?(current_user)
          render json: business, status: :ok
        else
          render json: { error: "Unauthorized" }, status: :forbidden
        end
      end

      private

      def business_params
        params.require(:business).permit(:name)
      end
    end
  end
end