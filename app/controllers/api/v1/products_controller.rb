class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[show update destroy]

respond_to :json

  def index
  products = Product.includes(:stocks, image_attachment: :blob)

  if params[:query].present?
    query = params[:query].downcase
    products = products.where(
      "LOWER(name) LIKE ? OR CAST(price AS TEXT) LIKE ?",
      "%#{query}%", "%#{query}%"
    )
  end

  # Order by most recent first
  products = products.order(created_at: :desc)

  # Paginate
  paginated = products.page(params[:page]).per(params[:per_page] || 10)

  render json: {
    products: ProductSerializer.new(paginated).serializable_hash,
    meta: {
      current_page: paginated.current_page,
      total_pages: paginated.total_pages,
      total_count: paginated.total_count,
      has_more: paginated.current_page < paginated.total_pages
    }
  }.to_json
end

  def show
  render json: ProductSerializer.new(@product).serializable_hash.to_json
end

def stats
  total_products = Product.count
  low_stock = Product.joins(:stocks)
                     .group(:id)
                     .having('SUM(stocks.quantity) < ?', 5)
                     .count
                     .size

  render json: {
    total_products: total_products,
    low_stock: low_stock
  }
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

def history
  product = Product.includes(:stocks).find(params[:id])

  history_data = product.stocks.order(created_at: :asc).map do |stock|
    {
      event: "Stock added: +#{stock.quantity}",
      actor: stock.added_by || "System",
      timestamp: stock.created_at
    }
  end

  render json: {
    name: product.name,
    created_at: product.created_at,
    history: history_data,
    qr_url: url_for(product.qr_code) # Adjust this based on how you handle QR codes
  }
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
    params.require(:product).permit(:name, :sku, :quantity, :price, :image)
  end
end