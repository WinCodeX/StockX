class UserBusiness < ApplicationRecord
  belongs_to :user
  belongs_to :business

enum role: { owner: 0, staff: 1 }
end
