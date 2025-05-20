module Api
  module V1
    class SalesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_product

      def index
        render json: @product.sales
      end

      def create
        quantity = sale_params[:quantity].to_i

        if quantity <= 0
          render json: { error: "Quantity must be greater than 0" }, status: :unprocessable_entity
          return
        end

        if @product.quantity < quantity
          render json: { error: "Insufficient stock available" }, status: :unprocessable_entity
          return
        end

        sale = @product.sales.build(sale_params)
        if sale.save
          @product.update(quantity: @product.quantity - quantity)
          render json: sale, status: :created
        else
          render json: { errors: sale.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

     

      def set_product
        @product = Product.find(params[:product_id])
      end

      def sale_params
        params.require(:sale).permit(:quantity, :note)
      end
    end
  end
end
