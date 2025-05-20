class Product < ApplicationRecord

has_many :stocks, dependent: :destroy

end
