class Invite < ApplicationRecord
  belongs_to :inviter, class_name: 'User'
  belongs_to :business

  before_create :generate_unique_code

  private

  def generate_unique_code
    loop do
      self.code = SecureRandom.hex(4)
      break unless Invite.exists?(code: code)
    end
  end
end