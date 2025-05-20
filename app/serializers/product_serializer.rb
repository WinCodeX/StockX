class ProductSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :sku, :price, :quantity, :total_stock

  has_many :stocks

  attribute :total_stock do |object|
    object.stocks.sum(:quantity)
  end
end