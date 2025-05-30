class BusinessInvite < ApplicationRecord
  belongs_to :inviter
  belongs_to :business
end
