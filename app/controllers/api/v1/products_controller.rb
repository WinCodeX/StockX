module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authenticate_request
      before_action :set_product, only: [:show, :update, :destroy]

      def index
        render json: Product.all
      end

      def show
        render json: @product
      end

      def create
        product = Product.new(product_params)
        if product.save
          render json: product, status: :created
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @product.update(product_params)
          render json: @product
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @product.destroy
        head :no_content
      end

      private

      def authenticate_request
        header = request.headers['Authorization']
        token = header.split.last if header
        decoded = JsonWebToken.decode(token)
        @current_user = User.find_by(id: decoded[:user_id]) if decoded
        render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
      end

      def set_product
        @product = Product.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Product not found' }, status: :not_found
      end

      def product_params
        params.require(:product).permit(:name, :sku, :quantity, :price)
      end
    end
  end
end
