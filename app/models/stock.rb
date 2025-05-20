class Stock < ApplicationRecord
  belongs_to :product
validates :quantity, presence: true, numericality: true
end
