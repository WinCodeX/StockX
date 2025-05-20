class SaleSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :quantity, :total_price, :created_at

  belongs_to :product
end