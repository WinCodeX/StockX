class Product < ApplicationRecord

has_many :stocks, dependent: :destroy
has_many :sales, dependent: :destroy
has_one_attached :image
has_one_attached :qr_code

def total_stock
  stocks.sum(:quantity)
end


def qr_code_url
    Rails.application.routes.url_helpers.url_for(qr_code) if qr_code.attached?
  end

end
