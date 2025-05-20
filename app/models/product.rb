class Product < ApplicationRecord

has_many :stocks, dependent: :destroy
has_many :sales, dependent: :destroy


def total_stock
  stocks.sum(:quantity)
end

end
