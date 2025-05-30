class BusinessInvite < ApplicationRecord
  belongs_to :inviter, class_name: 'User'
  belongs_to :business
end
