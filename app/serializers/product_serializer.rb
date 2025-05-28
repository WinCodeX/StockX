class ProductSerializer
  include FastJsonapi::ObjectSerializer
  include Rails.application.routes.url_helpers  # 👈 Ensure url_for works properly

  attributes :id, :name, :sku, :price, :quantity, :total_stock

  has_many :stocks

  attribute :image_url do |product|
    if product.image.attached?
      url_for(product.image)
    end
  end

  attribute :total_stock do |object|
    object.stocks.sum(:quantity)
  end
end