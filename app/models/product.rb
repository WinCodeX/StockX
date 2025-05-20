class Product < ApplicationRecord

has_many :stocks, dependent: :destroy

def total_stock
  stocks.sum(:quantity)
end

end
