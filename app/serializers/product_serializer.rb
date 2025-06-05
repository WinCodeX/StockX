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

attribute :qr_code_url do |product|
    if product.qr_code.attached?
      url_for(product.qr_code)
    end
  end

  attribute :total_stock do |object|
    object.stocks.sum(:quantity)
  end
end