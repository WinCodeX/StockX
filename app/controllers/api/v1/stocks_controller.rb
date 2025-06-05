module Api
  module V1
    class StocksController < ApplicationController
      before_action :authenticate_user!
      before_action :set_product

      def index
        render json: @product.stocks
      end

      def create
        stock = @product.stocks.build(stock_params)
        stock.added_by = current_user.username # or current_user.name if available

        if stock.save
          render json: stock, status: :created
        else
          render json: { errors: stock.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_product
        @product = Product.find(params[:product_id])
      end

      def stock_params
        params.require(:stock).permit(:quantity, :note)
        # Note: we don’t permit :added_by here because it's set from the server
      end
    end
  end
end