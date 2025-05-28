class ProductSerializer
  include FastJsonapi::ObjectSerializer
  include Rails.application.routes.url_helpers # Ensure `url_for` works

  attributes :id, :name, :sku, :price, :quantity, :total_stock

  has_many :stocks

  attribute :image_url do |product|
    if product.image.attached?
      Rails.application.routes.url_helpers.url_for(product.image)
    end
  end

  attribute :total_stock do |object|
    object.stocks.sum(:quantity)
  end
end