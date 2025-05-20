class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[show update destroy]

  def index
  products = Product.includes(:stocks).all
  products = products.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
  products = products.page(params[:page]).per(params[:per_page] || 10)

  render json: {
    products: ProductSerializer.new(products).serializable_hash,
    meta: {
      current_page: products.current_page,
      total_pages: products.total_pages,
      total_count: products.total_count
    }
  }
end

  def show
  render json: ProductSerializer.new(@product).serializable_hash.to_json
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

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Product not found' }, status: :not_found
  end

  def product_params
    params.require(:product).permit(:name, :sku, :quantity, :price)
  end
end