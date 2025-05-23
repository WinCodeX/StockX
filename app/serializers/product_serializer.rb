class ProductSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :sku, :price, :quantity, :total_stock

  has_many :stocks

 attribute :image_url do |product|
    Rails.application.routes.url_helpers.rails_blob_url(product.image, only_path: true) if product.image.attached?
  end

  attribute :total_stock do |object|
    object.stocks.sum(:quantity)
  end
end