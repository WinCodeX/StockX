class Invite < ApplicationRecord
  belongs_to :inviter
  belongs_to :business
end
